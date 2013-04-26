require 'host_dns_lookup'

desc "update hosts table to reflect current state of DNS"
task :fetch_hosts_dns => :environment do
  HostDnsLookup.new(Host.all).fetch_hosts_dns
end
