class MostRecentHitData
  attr_reader :most_recent_hit_on_date, :hits

  def initialize(hit_scope, hit_on_date)
    @most_recent_hit_on_date = hit_on_date
    @hits = hit_scope.without_zero_status_hits.most_recent_hits(@most_recent_hit_on_date).in_count_order
  end

  def biggest_hit_count
    @biggest_hit_count ||= @hits.most_hits
  end

  def hit_counts_by_status
    @hit_counts_by_status ||= @hits.counts_by_status
  end

  def total_hits
    @total_hits ||= @hits.total_hits
  end
end
