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

  def summarise_url_state
    urls.group(:workflow_state).count
  end

  def aggregated_totals
    self.totals.aggregated
  end

  def to_param
    abbr
  end
end
