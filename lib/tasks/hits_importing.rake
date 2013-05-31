require 'hits_importer'

desc "import hits data from tsv files"
task :import_hits, [:data_file] => :environment do |t, args|
  Rake::Task['import_hits:fast'].invoke(args[:data_file])
end
namespace :import_hits do
  desc "Import hits data quickly, will not cope well with existing data"
  task :fast, [:data_file] => :environment do |t, args|
    HitsImporter::Fast.new(args[:data_file]).import!
  end
  desc "Import hits data in a more robust (slow) fashion, will happily cope with existing data"
  task :robust, [:data_file] => :environment do |t, args|
    HitsImporter::Robust.new(args[:data_file]).import!
  end
end
