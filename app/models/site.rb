class Site < ActiveRecord::Base
#  attr_accessible :homepage, :query_params, :site, :tna_timestamp
  belongs_to :organisation
  has_many :hosts
  has_many :hits, through: :hosts

  def aggregated_hits
    self.hits.aggregated
  end

  def to_param
    site
  end
end
