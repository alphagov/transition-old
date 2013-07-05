require 'csv-mapper'

module Transition
  module Import
    class Urls
      def self.from_csv!(site_abbr, filename)
        site = Site.find_by_site!(site_abbr)
        successes, failures = 0, 0
        CsvMapper.import(filename) do
          map_to Url
          named_columns

          url('Url')

          after_row lambda { |row, url|
            url.site = site
            if (url.save rescue false)
              successes += 1
            else
              puts "#{url.errors.messages.inspect}: #{row.inspect}"
              failures += 1
            end
          }
        end

        puts "#{successes} successfully imported, #{failures} failed."
      end
    end
  end
end
