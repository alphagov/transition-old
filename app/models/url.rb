class Url < ActiveRecord::Base
  include Workflow

  belongs_to :site
  delegate :new_url, to: :mapping, allow_nil: true

  # validations
  validates :url, uniqueness: {case_sensitive: false}
  validates :site, presence: true

  workflow do
    state :new do
      event :archive, :transitions_to => :archived
      event :manual, :transitions_to => :manual
    end

    state :manual do
      event :redirect, :transitions_to => :redirected
    end

    state :archived         # Terminal, 410
    state :redirected       # Terminal, 301
  end

  def manual(new_url = nil)
    set_mapping_url(new_url) if new_url
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