module ScrapeResultsHelper
  COLUMN_NAMES = %w(id title summary body updated_at old_urls)

  def to_csv(scrape_results)
    CSV.generate do |csv|
      csv << COLUMN_NAMES

      scrape_results.each do |result|
        csv << result.attributes.merge(result.field_values).values_at(*COLUMN_NAMES)
      end
    end.html_safe
  end
end
