require 'host_dns_lookup'
require 'organisation_manages_own_redirects_flagger'

desc "update hosts table to reflect current state of DNS"
task :fetch_hosts_dns => :environment do
  HostDnsLookup.new(Host.all).fetch_hosts_dns
end

desc "update organisation 'manages_own_redirects' flag, based on cname of all hosts"
task :update_organisation_redirect_flag => :environment do
  OrganisationManagesOwnRedirectsFlagger.new(Organisation.scoped).flag!
end
