class MostRecentHitData
  attr_reader :most_recent_hit_on_date, :hits, :biggest_hit_count,
              :hit_counts_by_status, :total_hits

  def initialize(hit_scope, hit_on_date)
    @most_recent_hit_on_date = hit_on_date
    @hits = hit_scope.without_zero_status_hits.most_recent_hits(@most_recent_hit_on_date).in_count_order
    @biggest_hit_count = @hits.most_hits
    @hit_counts_by_status = @hits.counts_by_status
    @total_hits = @hits.sum(:count)
  end
end