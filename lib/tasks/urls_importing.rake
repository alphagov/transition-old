require 'transition/import/urls'

namespace :import_urls do
  desc 'import urls for a site from csv'
  task :fast, [:site, :csv_file] => :environment do |t, args|
    Transition::Import::Urls.from_csv!(args[:site], args[:csv_file])
  end
end