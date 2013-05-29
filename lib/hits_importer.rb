require 'csv'
class HitsImporter
  def initialize(data_file)
    @data_file = data_file
  end

  def import!
    Hit.leave_uniqueness_check_to_db = true
    consume_data do |hit_row|
      host = hosts[hit_row[:host]]
      if host.nil?
        $stdout.print 'E'
        $stderr.puts "ERROR: Host missing #{hit_row[:host]}, can't import #{hit_row.inspect}"
      else
        result = create_or_update_hit_for_host_from_row(host, hit_row)
        if result[:ok]
          $stdout.print '.'
        else
          $stdout.print 'F'
          $stderr.puts "ERROR: Can't import #{hit_row.inspect}, #{result[:hit].errors.full_messages}"
        end
      end
    end
  end

  def fetch_hit_scope(host, hit_row)
    Hit.where(host_id: host.id, path: hit_row[:path], http_status: hit_row[:status], hit_on: hit_row[:date])
  end

  def create_or_update_hit_for_host_from_row(host, hit_row)
    update_hit(fetch_hit_scope(host, hit_row).build, hit_row[:count])
  rescue ActiveRecord::RecordNotUnique
    update_hit(fetch_hit_scope(host, hit_row).first, hit_row[:count])
  end

  def update_hit(hit, count)
    hit.count = count
    {ok: hit.save, hit: hit}
  end

  def find_or_create_hit_for_host_from_row(host, hit_row)
    hit_scope = fetch_hit_scope(host, hit_row)
    if hit_scope.first.present?
      hit_scope.first
    else
      hit_scope.build
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
                                    col_sep: "\t" }).each do |hit_row|
      yield hit_row
    end
  end
end