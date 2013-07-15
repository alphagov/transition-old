class UrlGroupType < ActiveRecord::Base

  # relationships
  has_many :url_groups, dependent: :restrict

  # validations
  validates :name, uniqueness: {case_sensitive: false}

end