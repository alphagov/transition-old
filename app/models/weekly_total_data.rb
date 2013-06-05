class WeeklyTotalData < TotalData

  def initialize(total_scope, range, from_site_aggregate = false)
    super(total_scope)
    @range = range
    @from_site_aggregate = from_site_aggregate
  end

  def max_weekly_count
    @max_weekly_count ||= totals.max_weekly_count(from_site_aggregate: @from_site_aggregate)
  end

  def totals_by_week
    @totals_by_week ||= @totals.to_a.group_by {|t| t.week}
  end

  def weeks
    @weeks ||= @range.step(7).map { |week_start| week_start.strftime("%Y-W%U") }
  end

  def each_week
    weeks.each do |week|
      yield week, (totals_by_week[week] || [])
    end
  end
end
