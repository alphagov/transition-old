class Organisation < ActiveRecord::Base
  has_many :sites
  has_many :hosts, through: :sites
  has_many :mappings, through: :sites
  has_many :totals, through: :hosts
  has_many :hits, through: :sites
  has_many :urls, through: :sites

  def self.with_counts
    scoped.
      select('organisations.*, sites_count.count as sites_count, hosts_count.count as hosts_count, mappings_count.count as mappings_count').
      joins('
      left outer JOIN (
        select count(`sites`.id) as count, `sites`.organisation_id
          from `sites`
         group by `sites`.organisation_id
      ) as sites_count ON sites_count.organisation_id = organisations.id

      left outer JOIN (
        select count(`hosts`.id) as count, `sites`.organisation_id
          from `hosts`
         inner join `sites` on `hosts`.site_id = `sites`.id
         group by `sites`.organisation_id
      ) as hosts_count ON hosts_count.organisation_id = organisations.id

      left outer JOIN (
        select count(`mappings`.id) as count, `sites`.organisation_id
          from `mappings`
         inner join `sites` on `mappings`.site_id = `sites`.id
         group by `sites`.organisation_id
      ) as mappings_count ON mappings_count.organisation_id = organisations.id
      ').
      group('organisations.id')
  end

  # grab the closest urls either side of the given url
  def adjacent_urls(url, count = 15)
    ordered_urls = urls.order('sites.id ASC, urls.id ASC')
    earlier_urls = ordered_urls.where('urls.id < ?', url.id).last(count - 1)
    later_urls = ordered_urls.where('urls.id > ?', url.id).first(count - 1)
    url_list = earlier_urls + [url] + later_urls

    url_position = url_list.find_index(url)
    start_slice = [url_position - (count / 2), 0].max
    end_slice = start_slice + count
    if end_slice > url_list.size
      start_slice = [start_slice - end_slice + url_list.size, 0].max
      end_slice = url_list.size + 1
    end
    url_list.slice(start_slice...end_slice)
  end

  def weekly_totals
    self.totals.aggregated_by_week_and_site
  end

  def self.manages_own_redirects
    scoped.where(manages_own_redirects: true)
  end

  def self.gds_manages_redirects
    scoped.where(manages_own_redirects: false)
  end

  def sites_count
    read_attribute('sites_count') || sites.count
  end

  def mappings_count
    read_attribute('mappings_count') || mappings.count
  end

  def hosts_count
    read_attribute('hosts_count') || hosts.count
  end

  def aggregated_totals
    self.totals.aggregated
  end

  def to_param
    abbr
  end
end
