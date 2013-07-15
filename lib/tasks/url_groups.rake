require 'transition/url_groups'

namespace :url_groups do
  desc 'seed url group types'
  task :seed_group_types => :environment do
    Transition::UrlGroups.seed_group_types
  end

  desc 'seed some url groups'
  task :seed_groups, [:org_abbr] => :environment do |t, args|
    Transition::UrlGroups.seed_groups(args[:org_abbr])
  end
end
