class TotalData
  attr_reader :totals

  def initialize(total_scope)
    @totals = total_scope.without_zero_status_totals().in_date_order
  end
end
