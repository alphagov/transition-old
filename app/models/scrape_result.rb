class ScrapeResult < ActiveRecord::Base

  # relationships
  belongs_to :scrapable, polymorphic: true

  # validations
  validates :scrapable, presence: true
  validate :ensure_mandatory_fields_present

  def ensure_mandatory_fields_present
    if scrapable and scrapable.scrape_finished? and scrapable.content_type
      scrapable.content_type.scrapable_fields.mandatory.each do |scrapable_field|
        errors.add(:base, "#{scrapable_field.name.humanize} must be populated before scrape is marked as final") if field_values[scrapable_field.name].blank?
      end
    end
  end

  def field_values
    data ? @data_hash ||= JSON.parse(data) : {}
  end

  def self.find_by_url_group_all_scraped(site)
    sql = <<-SQL
      SELECT
        r.*, MIN(u.scrape_finished) as all_scraping_finished
      FROM
        scrape_results r
      INNER JOIN url_groups g ON g.id = r.scrapable_id AND r.scrapable_type = 'UrlGroup'
      INNER JOIN urls u ON u.url_group_id = g.id
      WHERE
        u.site_id = ?
      HAVING all_scraping_finished = 1
SQL

    ScrapeResult.find_by_sql([sql, site.id])
  end

  delegate :organisation, to: :scrapable

  def urls
    case scrapable
      when Url
        [scrapable]
      when UrlGroup
        scrapable.urls
      else
        raise 'wtfbbq'
    end
  end
end
