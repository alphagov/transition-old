class Total < ActiveRecord::Base
  belongs_to :host

  def self.without_zero_status_totals
    scoped.where('http_status NOT IN ("0", "00", "000")')
  end

  def self.in_date_order
    scoped.order('total_on')
  end

  def self.aggregated
    scoped.select('sum(totals.count) as count, totals.http_status, totals.total_on').group(:http_status, :total_on)
  end

end
