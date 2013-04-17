# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'yaml'
require 'htmlentities'

#
#  load sites
#
# seeding requires a local checkout of the redirector project ..
# system 'git clone --depth 1 git@github.com:alphagov/redirector.git'

dirs = Dir.glob("redirector/data/sites/*.yml")

dirs.each do |file|
  s = YAML.load_file file

  ackronym = s['site'].sub(/_.*$/, '')
  title = HTMLEntities.new.decode s['title']

  organisation = Organisation.find_or_initialize_by_ackronym(ackronym)
  organisation.update_attributes({
    title: title,
    launch_date: s['redirection_date'],
    homepage: s['homepage'],
    furl: s['furl']
  })

  query_params = s['options'] ? s['options'].sub(/^.*--query-string /, '') : ""

  site = Site.find_or_initialize_by_site(s['site'])
  site.organisation_id = organisation
  site.tna_timestamp = s['tna_timestamp']
  site.query_params = query_params
  site.homepage = s['homepage']
  site.furl = s['furl']
  site.save

  [s['host'], s['aliases']].flatten.each do |name|
    if name
      host = Host.find_or_initialize_by_host(name)
      host.site_id = site
      host.save
    end
  end
end
