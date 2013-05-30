class Host < ActiveRecord::Base
#  attr_accessible :cname, :host, :live_cname, :ttl
  belongs_to :site
  has_many :hits
  has_many :totals

  def to_param
    host
  end
end
