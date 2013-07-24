class ScrapableField < ActiveRecord::Base
  attr_accessible :name, :type

  # relationships
  has_and_belongs_to_many :content_types

  # validations
  validates_presence_of :name, :type
  validates_uniqueness_of :name

  # scopes
  scope :mandatory, where(mandatory: true)

  def self.inheritance_column
    'is_not_in_use'
  end
end
