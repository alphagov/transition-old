class AggregratedMostRecentHitData < MostRecentHitData

  def biggest_hit_count
    @biggest_hit_count ||= @hits.most_hits(from_aggregate: true)
  end

  def hit_counts_by_status
    @hit_counts_by_status ||= @hits.counts_by_status(from_aggregate: true)
  end

  def total_hits
    @total_hits ||= @hits.total_hits(from_aggregate: true)
  end
end
