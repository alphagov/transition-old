class Url < ActiveRecord::Base
  # relationships
  belongs_to :site
  belongs_to :guidance, class_name: 'UrlGroup'
  belongs_to :series, class_name: 'UrlGroup'
  belongs_to :content_type
  belongs_to :user_need
  has_one :scrape, as: :scrapable, class_name: 'ScrapeResult'
  delegate :new_url, :http_status, to: :mapping, allow_nil: true
  delegate :request_uri, :to_s, to: :uri

  # validations
  validates :url, uniqueness: {case_sensitive: false}
  validates :site, presence: true
  validates :guidance, presence: true, if: Proc.new { |url| url.content_type.try(:mandatory_guidance) }

  # scopes
  scope :final, where('state = ?', 'finished')
  scope :manual, where('for_scraping = ? or for_scraping is null', false)
  scope :for_content_types, ->(content_types) { where('urls.content_type_id in (?)', content_types.map(&:id)) }
  scope :for_scraping, where(for_scraping: true)
  scope :in_scraping_order,
        joins('LEFT JOIN content_types ON urls.content_type_id = content_types.id').
        joins('LEFT JOIN url_groups ON urls.guidance_id = url_groups.id').
        includes(:content_type, :guidance).
        order('content_types.type, content_types.subtype, url_groups.name, urls.id')

  def self.for_type(type)
    content_types = ContentType.where(type: type)
    content_types.any? ? for_content_types(content_types) : scoped
  end

  def next(scope)
    scope.where('id > ?', id).order('id ASC').first || self
  end

  def scrape_result
    scrape_result_delegate.scrape
  end

  def build_scrape_result(options = {})
    scrape_result_delegate.build_scrape(options)
  end

  def create_scrape_result!(options = {})
    scrape_result_delegate.create_scrape!(options)
  end

  def state
    super.to_sym
  end

  # return mapping if there is one
  def mapping
    return nil if host.nil?
    @mapping ||= site.mappings.find_by_path(request_uri)
  end

  # if existing mapping found then update path else create mapping
  def set_mapping_url(new_url)
    map = mapping
    if host.nil?
      map = Mapping.new
      map.errors.add(:base, "No site host found")
    elsif map
      map.update_attributes(new_url: new_url)
    else
      map = site.mappings.redirects.create(new_url: new_url, path: request_uri)
    end
    map
  end

  def link
    url
  end

  def organisation
    site.organisation
  end

  private

  # is scraping done per guidance as opposed to per url
  def scrape_for_url_group?
    content_type.try(:detailed_guide?) and guidance
  end

  def scrape_result_delegate
    scrape_for_url_group? ? guidance : self
  end

  def host
    @host ||= site.hosts.find_by_host(uri.host)
  end

  def uri
    @uri ||= URI.parse(url)
  end
end
