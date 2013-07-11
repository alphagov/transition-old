require 'csv-mapper'

module Transition
  module Import
    class ContentTypes
      def self.from_csv!(filename)
        created, updated, failures = 0, 0, 0
        CsvMapper.import(filename) do
          named_columns

          type      'Type'
          subtype   'Sub-Type'
          scrapable 'Scrapable?'

          after_row lambda { |row, type_struct|
            new_type = ContentType.where(type: type_struct.type, subtype: type_struct.subtype).first_or_initialize

            already_existed = new_type.persisted?
            new_type.scrapable = (type_struct.scrapable == 'Y')


            if(new_type.save rescue false)
              already_existed ? (updated += 1) : (created += 1)
            else
              puts "#{type_struct.errors.messages.inspect}: #{row.inspect}"
              failures += 1
            end
          }
        end

        puts "#{created} created, #{updated} updated, #{failures} failed."
      end
    end
  end
end
