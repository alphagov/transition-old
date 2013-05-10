require 'csv'

class HitDataExporter
  def initialize(hit_data, status_filter = 'all')
    @hit_data = hit_data
    @status_filter = status_filter
  end

  def generate_csv_using_host(host)
    CSV.generate do |csv|
      csv << ['Count', 'URL']
      @hit_data.hits.each do |hit|
        csv << [hit.count, 'http://'+host.host+hit.path]
      end
    end
  end

  def filename(prefix = nil)
    [prefix, @status_filter, 'hits', @hit_data.most_recent_hit_on_date.strftime('%Y-%m-%d')].compact.join('-')+'.csv'
  end
end
