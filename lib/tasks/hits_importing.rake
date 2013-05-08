require 'hits_importer'

desc "import hits data from tsv files"
task :import_hits, [:data_file] => :environment do |t, args|
  HitsImporter.new(args[:data_file]).import!
end
