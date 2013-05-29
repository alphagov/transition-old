require 'csv'
class TotalsImporter
  def initialize(data_file)
    @data_file = data_file
  end

  def import!
    consume_data do |total_row|
      hostname = total_row[:host]
      next if hostname =~ /^aka/      
      host = hosts[hostname]
      if host.nil?
        $stderr.puts "ERROR: Host missing #{hostname}, can't import #{total_row.inspect}"
      else
        result = create_or_update_total_for_host_from_row(host, total_row)
        unless result[:ok]
          $stderr.puts "ERROR: Can't import #{total_row.inspect}, #{result[:total].errors.full_messages}"
        end
      end
    end
  end

  def fetch_total_scope(host, total_row)
    Total.where(host_id: host.id, http_status: total_row[:status], total_on: total_row[:date])
  end

  def create_or_update_total_for_host_from_row(host, total_row)
    update_total(fetch_total_scope(host, total_row).build, total_row[:count])
  rescue ActiveRecord::RecordNotUnique
    update_total(fetch_total_scope(host, total_row).first, total_row[:count])
  end

  def update_total(total, count)
    total.count = count
    {ok: total.save, total: total}
  end

  def find_or_create_total_for_host_from_row(host, total_row)
    total_scope = fetch_total_scope(host, total_row)
    if total_scope.first.present?
      total_scope.first
    else
      total_scope.build
    end
  end

  def hosts
    @hosts ||= Host.all.inject({}) { |m, h| m.merge(h.host => h) }
  end

  def consume_data(&block)
    Dir[@data_file].each do |data_file|
      $stdout.puts "Processing: #{data_file}"
      consume_data_file(data_file, &block)
      $stdout.puts "\n"
    end
  end

  def consume_data_file(data_file)
    CSV.new(File.open(data_file), { headers: true,
                                    converters: [:numeric, :date],
                                    header_converters: :symbol,
                                    col_sep: "\t" }).each do |total_row|
      yield total_row
    end
  end
end
