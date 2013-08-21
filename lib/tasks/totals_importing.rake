require 'totals_importer'

desc "import totals data from tsv files (uses fast model)"
task :import_totals, [:data_file] => :environment do |t, args|
  Rake::Task['import_totals:fast'].invoke(args[:data_file])
end
namespace :import_totals do
  desc "Empty the totals table. Useful before a fast import."
  task :truncate => :environment do
    TotalsImporter::Fast.truncate!
  end
  desc "Import totals data quickly, will not cope well with existing data"
  task :fast, [:data_file] => :environment do |t, args|
    TotalsImporter::Fast.new(args[:data_file]).import!
  end
  desc "Import totals data in a more robust (slow) fashion, will happily cope with existing data"
  task :robust, [:data_file] => :environment do |t, args|
    TotalsImporter::Robust.new(args[:data_file]).import!
  end
end
