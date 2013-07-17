class ScrapableField < ActiveRecord::Base
  attr_accessible :name, :type

  validates_presence_of :name, :type
  validates_uniqueness_of :name

  has_and_belongs_to_many :content_types
end
