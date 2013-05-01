class HostDnsLookup
  attr_reader :hosts
  def initialize(hosts)
    @hosts = hosts
  end
  def check_dns(host, dns_server = DNS_SERVER)
    IO.popen("dig @#{dns_server} +trace '#{host}'")  do |f|
      f.lines.find do |line|
        if line.include?("CNAME")
          a = line.split(' ')
          return a[1],a[2],a[4]
        end
      end
    end
  end

  def fetch_hosts_dns
    hosts.each do |host|
      ttl, type, cname = check_dns(host.host)
      host.ttl = ttl
      host.cname = cname
      host.save
    end
  end
end