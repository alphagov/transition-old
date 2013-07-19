class Total < ActiveRecord::Base
  belongs_to :host

  before_validation :normalize_hit_on

  protected
  def self.as_week_of_year(column, as = 'week')
    "concat(year(total_on), '-W', lpad(week(#{column}), 2, '0')) as #{as}"
  end

  public
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
    scoped.select("#{as_week_of_year('total_on')}, host_id, http_status, sum(count) as count")
      .group('yearweek(total_on), host_id, http_status')
      .order('yearweek(total_on)')
  end

  def self.aggregated_by_week_and_site
    scoped.select("#{as_week_of_year('total_on')}, http_status, sum(count) as count")
      .group('yearweek(total_on), http_status')
      .order('yearweek(total_on)')
  end

  def self.from_aggregate(aggregated_scope, as='aggregated_totals')
    Total.unscoped.from(%{(#{aggregated_scope.to_sql}) as #{as}})
  end

  def self.max_weekly_count(opts = {})
    opts = {from_site_aggregate: false}.merge(opts)
    re_aggregate = Total.from_aggregate(scoped, 'inner_totals')
    re_aggregate =
      if opts[:from_site_aggregate]
        re_aggregate.group('week').select('sum(inner_totals.count) as count')
      else
        re_aggregate.group('week, host_id').select('inner_totals.host_id, sum(inner_totals.count) as count')
      end
    Total.from_aggregate(re_aggregate).maximum('aggregated_totals.count') || 0
  end

  def self.most_recent_total_on_date(opts = {})
    opts = {
      from_aggregate: false,
      fallback_date: Date.today
    }.merge(opts)
    if opts[:from_aggregate]
      Total.from_aggregate(scoped).maximum('aggregated_totals.total_on') || opts[:fallback_date]
    else
      scoped.maximum(:total_on) || opts[:fallback_date]
    end
  end

  def self.most_recent_totals(total_on_date = most_recent_total_on_date)
    scoped.where(total_on: total_on_date.beginning_of_day.to_date)
  end

  def week
    read_attribute('week') || total_on.strftime("%Y-W%U")
  end

  def prep_for_import
    normalize_hit_on
  end
  protected
  def normalize_hit_on
    self.total_on = total_on.beginning_of_day if total_on_changed?
  end
end
