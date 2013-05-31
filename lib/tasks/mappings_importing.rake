require 'mappings_importer'

desc "import mappings data from redirector csv files"
task :import_mappings, [:data_file] => :environment do |t, args|
  Rake::Task['import_mappings:fast'].invoke(args[:data_file])
end
namespace :import_mappings do
  desc "Import mappings data quickly, will not cope well with existing data"
  task :fast, [:data_file] => :environment do |t, args|
    MappingsImporter::Fast.new(args[:data_file]).import!
  end
  desc "Import mappings data in a more robust (slow) fashion, will happily cope with existing data"
  task :robust, [:data_file] => :environment do |t, args|
    MappingsImporter::Robust.new(args[:data_file]).import!
  end
end
