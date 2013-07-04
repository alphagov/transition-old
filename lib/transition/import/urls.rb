require 'csv-mapper'

module Transition
  module Import
    class Urls
      def self.import!(site_abbr, filename)
        site = Site.find_by_site!(site_abbr)
        CsvMapper.import(filename) do
          map_to Url
          named_columns

          url('Url')

          after_row lambda { |row, url|
            url.site = site
            url.save!
          }
        end
      end
    end
  end
end
