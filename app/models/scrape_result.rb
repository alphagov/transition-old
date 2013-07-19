class ScrapeResult < ActiveRecord::Base

  # relationships
  belongs_to :scrapable, polymorphic: true

  # validations
  validates :scrapable, presence: true
  validate :ensure_mandatory_fields_present

  def ensure_mandatory_fields_present
    if scrapable and scrapable.scrape_finished? and scrapable.content_type
      scrapable.content_type.scrapable_fields.mandatory.each do |scrapable_field|
        errors.add(:base, "#{scrapable_field.name.humanize} must be populated before scrape is marked as final") if field_value(scrapable_field.name).blank?
      end
    end
  end

  def field_values
    data ? @data_hash ||= JSON.parse(data) : {}
  end
end
