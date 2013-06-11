class HitRangeData
  attr_reader :start_date, :end_date, :hits

  def initialize(hit_scope, start_date, end_date)
    @start_date = start_date
    @end_date = end_date
    @hits = hit_scope.without_zero_status_hits.in_date_range(@start_date, @end_date).unique_pages_and_statuses.in_count_order
  end

  def biggest_hit_count
    @biggest_hit_count ||= @hits.most_hits({from_aggregate: true})
  end

  def hit_counts_by_status
    @hit_counts_by_status ||= @hits.counts_by_status
  end

  def total_hits
    @total_hits ||= @hits.total_hits(from_aggregate: true)
  end
end
