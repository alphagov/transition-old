class Organisation < ActiveRecord::Base
#  attr_accessible :ackronym, :furl, :homepage, :launch_date, :title
  has_many :sites
end
