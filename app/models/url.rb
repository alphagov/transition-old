class Url < ActiveRecord::Base
  belongs_to :site

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

  # return mapping if there is one
  def mapping
    uri = URI.parse(url)
    host_name = uri.host
    request_uri = uri.path
    request_uri += '?' + uri.query if uri.query.present?
    host = site.hosts.find_by_host(host_name)
    mapping = site.mappings.find_by_path(request_uri) if host
    mapping
  end
end