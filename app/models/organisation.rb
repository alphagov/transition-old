class Organisation < ActiveRecord::Base
  has_many :sites
  has_many :hosts, through: :sites
  has_many :mappings, through: :sites
  has_many :totals, through: :hosts

  def sites_count
    sites.count
  end

  def mappings_count
    mappings.count
  end

  def hosts_count
    hosts.count
  end

  def aggregated_totals
    self.totals.aggregated
  end

  def to_param
    abbr
  end
end
