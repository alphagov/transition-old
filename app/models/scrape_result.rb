class ScrapeResult < ActiveRecord::Base

  # relationships
  belongs_to :scrapable, polymorphic: true

  # scrapable
  validates :scrapable, presence: true

end