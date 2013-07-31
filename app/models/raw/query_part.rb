class Raw::QueryPart < ActiveRecord::Base
  attr_accessible :key, :value

  belongs_to :url, class_name: 'Raw::Url'
end
