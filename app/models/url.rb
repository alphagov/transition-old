class Url < ActiveRecord::Base
  belongs_to :site
  delegate :new_url, to: :mapping, allow_nil: true

  # validations
  validates :url, uniqueness: {case_sensitive: false}
  validates :site, presence: true

  def next
    site.urls.where('id > ?', id).order('id ASC').first
  end

  def workflow_state
    super.to_sym
  end

  def workflow_state=(value)
    write_attribute(:workflow_state, value)
  end

  def manual!(new_url = nil)
    self.workflow_state = :manual
    set_mapping_url(new_url) if new_url
  end

  def archive!
    self.workflow_state = :archive
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

  def to_s
    url
  end

  private

  def host
    @host ||= site.hosts.find_by_host(uri.host)
  end

  def request_uri
    @request_uri ||= uri.path + (uri.query.present? ? '?' + uri.query : '')
  end

  def uri
    @uri ||= URI.parse(url)
  end
end
