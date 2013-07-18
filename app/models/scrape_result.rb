class ScrapeResult < ActiveRecord::Base

  # relationships
  belongs_to :scrapable, polymorphic: true

  # scrapable
  validates :scrapable, presence: true

  def field_value(field_name)
    if data
      @data_hash ||= JSON.parse(data)
      @data_hash[field_name]
    end
  end
end