class UrlGroupType < ActiveRecord::Base
  GUIDANCE = 'Guidance'
  SERIES = 'Series'

  # relationships
  has_many :url_groups, dependent: :restrict

  # validations
  validates :name, uniqueness: {case_sensitive: false}

  def self.guidance
    find_by_name(GUIDANCE)
  end

  def self.series
    find_by_name(SERIES)
  end
end
