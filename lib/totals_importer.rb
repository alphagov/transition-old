require 'csv'
class TotalsImporter
  def initialize(data_file)
    @data_file = data_file
  end

  def import!
    consume_data_file do |total_row|
      host = Host.find_by_host(total_row[:host])
      if host.nil?
        $stderr.puts "ERROR: Host missing #{total_row[:host]}, can't import #{total_row.inspect}"
      else
        total = find_or_create_total_for_host_from_row(host, total_row)
        total.count = total_row[:count]
        if !total.save
          $stderr.puts "ERROR: Can't import #{total_row.inspect}, #{total.errors.full_messages}"
        end
      end
    end
  end

  def find_or_create_total_for_host_from_row(host, total_row)
    total_scope = Total.where(host_id: host.id, http_status: total_row[:status], total_on: total_row[:date])
    if total_scope.first.present?
      total_scope.first
    else
      total_scope.build
    end
  end

  def consume_data_file
    CSV.new(File.open(@data_file), { headers: true,
                                     converters: [:numeric, :date],
                                     header_converters: :symbol,
                                     col_sep: "\t" }).each do |total_row|
      yield total_row
    end
  end
end