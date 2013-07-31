class Raw::Url < ActiveRecord::Base
  attr_accessible :host, :path, :query, :url, :extension
end
