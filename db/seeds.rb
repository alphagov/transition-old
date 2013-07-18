# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'yaml'
require 'htmlentities'

unless User.find_by_email("test@example.com")
  u = User.new
  u.email = "test@example.com"
  u.name = "Test User"
  u.permissions = ["signin"]
  u.save
end
#
#  load sites
#
# seeding requires a local checkout of the redirector project in the data directory
# git clone git@github.com:alphagov/redirector.git

dirs = Dir.glob("data/redirector/data/sites/*.yml")

dirs.each do |file|
  s = YAML.load_file file

  abbr = s['site'].sub(/_.*$/, '')
  title = HTMLEntities.new.decode s['title']

  organisation = Organisation.find_or_initialize_by_abbr(abbr)
  organisation.update_attributes({
    title: title,
    launch_date: s['redirection_date'],
    homepage: s['homepage'],
    furl: s['furl'],
    css: s['css'] || nil
  })

  query_params = s['options'] ? s['options'].sub(/^.*--query-string /, '') : ""

  site = Site.find_or_initialize_by_site(s['site'])
  site.organisation = organisation
  site.tna_timestamp = s['tna_timestamp']
  site.query_params = query_params
  site.homepage = s['homepage']
  site.furl = s['furl']
  site.save

  [s['host'], s['aliases']].flatten.each do |name|
    if name
      host = Host.find_or_initialize_by_host(name)
      host.site = site
      host.save
    end
  end
end

Transition::Import::ContentTypes.from_csv!('data/seeds/content_types.csv')
Transition::Import::ScrapableFields.seed!

# seed url group types
Transition::UrlGroups.seed_group_types
