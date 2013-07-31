class Raw::QueryPart < ActiveRecord::Base
  attr_accessible :key, :value

  belongs_to :raw_url
end
