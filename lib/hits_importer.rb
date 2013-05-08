require 'csv'
class HitsImporter
  def initialize(data_file)
    @data_file = data_file
  end

  def import!
    consume_data_file do |hit_row|
      host = Host.find_by_host(hit_row[:host])
      if host.nil?
        $stdout.print 'E'
        $stderr.puts "ERROR: Host missing #{hit_row[:host]}, can't import #{hit_row.inspect}"
      else
        hit = find_or_create_hit_for_host_from_row(host, hit_row)
        hit.count = hit_row[:count]
        if hit.save
          $stdout.print '.'
        else
          $stdout.print 'F'
          $stderr.puts "ERROR: Can't import #{hit_row.inspect}, #{hit.errors.full_messages}"
        end
      end
    end
  end

  def find_or_create_hit_for_host_from_row(host, hit_row)
    hit_scope = Hit.where(host_id: host.id, path: hit_row[:path], http_status: hit_row[:status], hit_on: hit_row[:date])
    if hit_scope.first.present?
      hit_scope.first
    else
      hit_scope.build
    end
  end

  def consume_data_file
    CSV.new(File.open(@data_file), { headers: true,
                                     converters: [:numeric, :date],
                                     header_converters: :symbol,
                                     col_sep: "\t" }).each do |hit_row|
      yield hit_row
    end
  end
end