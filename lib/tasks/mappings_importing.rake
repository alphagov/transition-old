require 'mappings_importer'

desc "import mappings data from redirector csv files"
task :import_mappings, [:data_file] => :environment do |t, args|
  MappingsImporter.new(args[:data_file]).import!
end
