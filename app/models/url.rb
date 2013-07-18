class Url < ActiveRecord::Base
  # relationships
  belongs_to :site
  belongs_to :url_group
  belongs_to :content_type
  has_one :scrape_result, :as => :scrapable
  delegate :new_url, to: :mapping, allow_nil: true

  # validations
  validates :url, uniqueness: {case_sensitive: false}
  validates :site, presence: true

  # scopes
  scope :scrapable, where(is_scrape: true)
  scope :order_for_scrape,
        joins('LEFT JOIN content_types ON urls.content_type_id = content_types.id').
        joins('LEFT JOIN url_groups ON urls.url_group_id = url_groups.id').
        includes(:content_type, :url_group).
        order('content_types.type, content_types.subtype, url_groups.name')

  def next
    site.urls.where('id > ?', id).order('id ASC').first
  end

  def workflow_state
    super.to_sym
  end

  def workflow_state=(value)
    write_attribute(:workflow_state, value)
  end

  # return mapping if there is one
  def mapping
    return nil if host.nil?
    @mapping ||= site.mappings.find_by_path(request_uri)
  end

  # if existing mapping found then update path else create maaping
  def set_mapping_url(new_url)
    raise "No site host found for #{url}" if host.nil?
    if mapping
      mapping.update_attributes!(new_url: new_url)
    else
      map = site.mappings.build(new_url: new_url, path: request_uri, http_status: '301')
      map.save!
    end
  end

  def request_uri
    @request_uri ||= uri.path + (uri.query.present? ? '?' + uri.query : '')
  end

  def to_s
    url
  end

  private

  def host
    @host ||= site.hosts.find_by_host(uri.host)
  end

  def uri
    @uri ||= URI.parse(url)
  end
end
