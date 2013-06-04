class MappingsData
  attr_reader :mappings

  def initialize(mappings)
    @mappings = mappings
  end

  def count
    @count ||= @mappings.count
  end

  def counts_by_http_status
    @counts_by_http_status ||= @mappings.group('http_status').reorder('http_status').count
  end

  def http_statuses
    @http_statuses ||= counts_by_http_status.keys.sort
  end
end
