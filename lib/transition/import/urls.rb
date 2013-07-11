require 'csv-mapper'

module Transition
  module Import
    class Urls
      def self.from_csv!(site_abbr, filename)
        begin
          site = Site.find_by_site!(site_abbr)
          logger.info "Importing site urls for #{site.organisation.title} - #{site.site}"
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
                Urls.logger.error "#{url.errors.messages.inspect}: #{row.inspect}"
                failures += 1
              end
            }
          end

          logger.info "#{successes} successfully imported, #{failures} failed."
          logfilename
        ensure
          reset_logger
        end
      end

      def self.logger
        unless @logger
          FileUtils.mkdir_p Rails.root.join('log', 'import_urls')
          @logfilename = "#{Time.now.strftime('%Y%m%d-%H:%M:%S')}.log"
          @logger = AuditLogger.new(Rails.root.join('log', 'import_urls', @logfilename), 'Import urls')
        end
        @logger
      end

      def self.logfilename
        @logfilename
      end

      def self.reset_logger
        remove_instance_variable(:@logger) if instance_variable_defined?(:@logger)
      end
    end
  end
end
