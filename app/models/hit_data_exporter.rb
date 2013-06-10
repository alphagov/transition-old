require 'csv'

class HitDataExporter
  def initialize(hit_data, status_filter)
    @hit_data = hit_data
    @status_filter = status_filter || 'all'
  end

  def filtered_hits
    @hit_data.hits.with_status(@status_filter)
  end

  def generate_csv_using_host(host)
    CSV.generate do |csv|
      csv << ['Count', 'Status', 'URL']
      filtered_hits.each do |hit|
        csv << [hit.count, hit.http_status, 'http://'+host.host+hit.path]
      end
    end
  end

  def filename(prefix = nil)
    [prefix, @status_filter, 'hits', @hit_data.most_recent_hit_on_date.strftime('%Y-%m-%d')].compact.join('-')+'.csv'
  end
end
