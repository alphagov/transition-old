require 'csv'

module ScrapeResultsHelper
  COLUMN_NAMES = %w(id title summary organisation body updated_at old_url)

  def to_csv(scrape_results)
    CSV.generate do |csv|
      csv << COLUMN_NAMES

      scrape_results.each do |result|
        export_hash = result.attributes.merge(result.field_values)
        export_hash['organisation'] = result.organisation.abbr
        export_hash['body'] = Kramdown::Document.new(export_hash['body'], input: 'html').to_kramdown
        export_hash['old_url'] = %([#{result.urls.map { |u| %("#{u.url}") }.join(',')}])
        csv << export_hash.values_at(*COLUMN_NAMES)
      end
    end.html_safe
  end
end
