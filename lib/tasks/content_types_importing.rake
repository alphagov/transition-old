require 'transition/import/content_types'

desc 'import Inside Government content types from a given CSV file'
task :import_content_types, [:csv_file] => :environment do |t, args|
  Transition::Import::ContentTypes.from_csv!(args[:csv_file])
end
