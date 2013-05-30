class Site < ActiveRecord::Base
#  attr_accessible :homepage, :query_params, :site, :tna_timestamp
  belongs_to :organisation
  has_many :hosts
  has_many :hits, through: :hosts
  has_many :totals, through: :hosts
  has_many :mappings

  def aggregated_hits
    self.hits.aggregated
  end

  def aggregated_totals
    self.totals.aggregated
  end

  def to_param
    site
  end
end
