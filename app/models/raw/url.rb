# encoding: utf-8

class Raw::Url < ActiveRecord::Base
  attr_accessible :host, :path, :query, :url, :extension

  has_many :query_parts

  # Get me everything up to the last . that's not followed by /, then capture everything after it
  def self.parse_extension(path)
    path = CGI.unescape(path).strip.encode('UTF-16', :invalid => :replace, :replace => '').encode('UTF-8')
    /.*\.(?!.*\/)(.+)$/.match(path) && $1
  end
end
