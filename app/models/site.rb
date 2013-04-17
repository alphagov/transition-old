class Site < ActiveRecord::Base
#  attr_accessible :homepage, :query_params, :site, :tna_timestamp
  belongs_to :organisation
  has_many :hosts

  def to_param
    site
  end
end
