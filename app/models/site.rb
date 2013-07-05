class Site < ActiveRecord::Base
#  attr_accessible :homepage, :query_params, :site, :tna_timestamp
  belongs_to :organisation
  has_many :hosts
  has_many :hits, through: :hosts
  has_many :totals, through: :hosts
  has_many :mappings
  has_many :urls, dependent: :restrict

  def aggregated_hits
    self.hits.aggregated
  end

  def aggregated_totals
    self.totals.aggregated
  end

  def weekly_totals
    self.totals.aggregated_by_week_and_site
  end

  def default_host
    hosts.order(:id).first
  end

  def to_param
    site
  end
end
