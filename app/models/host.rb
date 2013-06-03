class Host < ActiveRecord::Base
#  attr_accessible :cname, :host, :live_cname, :ttl
  belongs_to :site
  has_many :hits
  has_many :totals

  def weekly_totals
    totals.aggregated_by_week
  end

  def to_param
    host
  end
end
