class Site < ActiveRecord::Base
#  attr_accessible :homepage, :query_params, :site, :tna_timestamp
  
  def to_param
    site
  end
end
