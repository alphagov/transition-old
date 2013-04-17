class Host < ActiveRecord::Base
#  attr_accessible :cname, :host, :live_cname, :ttl
  belongs_to :site

  def to_param
    host
  end
end
