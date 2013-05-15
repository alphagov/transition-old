require 'totals_importer'

desc "import totals data from tsv files"
task :import_totals, [:data_file] => :environment do |t, args|
  TotalsImporter.new(args[:data_file]).import!
end
