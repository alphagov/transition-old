require 'optic14n'

namespace :raw do
  desc 'import urls from line-separated files for the given directory'
  task :import_urls, [:url_files_dir] => :environment do |_, args|
    Transition::Import::Raw::Urls.from_dir!(args[:url_files_dir])
  end

  desc 'wipe all the raw urls/files to start again'
  task :wipe => :environment do |_, args|
    Transition::Import::Raw::Urls.wipe!
  end
end
