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

  def self.aggregated_by_week
    scoped.select("concat(year(total_on),'-W',week(total_on)) as week, host_id, http_status, sum(count) as count")
      .group('yearweek(total_on), host_id, http_status')
      .order('yearweek(total_on)')
  end

  def self.from_aggregate(aggregated_scope, as='aggregated_totals')
    Total.unscoped.from(%{(#{aggregated_scope.to_sql}) as #{as}})
  end

  def self.max_weekly_count
    re_aggregate = Total.from_aggregate(scoped, 'inner_totals').group('week, host_id').select('inner_totals.host_id, sum(inner_totals.count) as count')
    Total.from_aggregate(re_aggregate).maximum('aggregated_totals.count')
  end


 # SELECT MAX(aggregated_totals.count) AS max_id
 #   FROM (SELECT inner_totals.host_id, sum(inner_totals.count) as count
 #          FROM (SELECT concat(year(total_on),'-W',week(total_on)) as week, host_id, http_status, sum(count) as count
 #                 FROM `totals`
 #                  WHERE `totals`.`host_id` = 454 AND (http_status NOT IN ("0", "00", "000"))
 #                GROUP BY yearweek(total_on), host_id, http_status
 #                 ORDER BY total_on, yearweek(total_on)) as inner_totals
 #          GROUP BY host_id) as aggregated_totals

end
