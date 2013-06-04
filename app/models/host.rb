class Host < ActiveRecord::Base
  GDS_CNAME = '.gov.uk.edgekey.net.'
#  attr_accessible :cname, :host, :live_cname, :ttl
  belongs_to :site
  has_many :hits
  has_many :totals

  def weekly_totals
    totals.aggregated_by_week
  end

  def gds_managed?
    cname.present? && (cname =~ /#{Regexp.escape(GDS_CNAME)}\Z/)
  end

  def to_param
    host
  end
end
