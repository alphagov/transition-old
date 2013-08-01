require 'csv-mapper'

module Transition
  module Import
    class Urls
      def self.from_csv!(site_abbr, filename)
        site = Site.find_by_site!(site_abbr)
        logger, logfilename = new_logger(site)
        logger.info "Importing site urls for #{site.organisation.title} - #{site.site}"
        successes, failures = 0, 0
        CsvMapper.import(filename) do
          map_to Url
          named_columns

          url('Url')

          after_row lambda { |row, url|
            url.url = BLURI(url.url).canonicalize!.to_s
            url.site = site
            if (url.save rescue false)
              successes += 1
            else
              logger.error "#{url.errors.messages.inspect}: #{row.inspect}"
              failures += 1
            end
          }
        end

        logger.info "Urls - #{successes} successfully imported, #{failures} failed."
        logger.close
        logfilename
      end

      def self.new_logger(site)
        FileUtils.mkdir_p Rails.root.join('log', 'import_urls')
        logfilename = "#{site.site.gsub(' ', '_')}-#{Time.now.strftime('%Y%m%d-%H:%M:%S')}-#{rand(1...100).to_s}.log"
        logger = AuditLogger.new(Rails.root.join('log', 'import_urls', logfilename), 'Import urls')
        [logger, logfilename]
      end
    end
  end
end
