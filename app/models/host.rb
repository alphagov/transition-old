class Host < ActiveRecord::Base
#  attr_accessible :cname, :host, :live_cname, :ttl
  belongs_to :site
  has_many :hits

  def to_param
    host
  end
end
