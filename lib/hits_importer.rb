require 'csv'
class HitsImporter
  def initialize(data_file)
    @data_file = data_file
  end

  def import!
    consume_data_file do |hit_row|
      host = Host.find_by_host(hit_row[:host])
      if host.nil?
        puts "ERROR: Host missing #{hit_row[:host]}, can't import #{hit_row.inspect}"
      else
        hit = Hit.new(host: host, path: hit_row[:path], http_status: hit_row[:status], hit_on: hit_row[:date], count: hit_row[:count])
        if hit.save
          print '.'
        else
          puts "ERROR: Can't import #{hit_row.inspect}, #{hit.errors.full_messages}"
        end
      end
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