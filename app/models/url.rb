class Url < ActiveRecord::Base
  belongs_to :site

  # validations
  validates :url, uniqueness: {case_sensitive: false} 
  validates :site, presence: true

end