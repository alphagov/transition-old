class Raw::Url < ActiveRecord::Base
  attr_accessible :host, :path, :query, :url, :extension

  has_many :query_parts
end
