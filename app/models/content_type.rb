##
# An Inside Government content type
class ContentType < ActiveRecord::Base
  attr_accessible :scrapable, :subtype, :type

  validates_presence_of :type
  validates_uniqueness_of :subtype, scope: :type, case_sensitive: false

  def to_s
    [type, subtype.presence].compact.join(' / ')
  end

  def ContentType.inheritance_column
    'is_not_in_use'
  end
end
