require 'csv'
class HostBasedImporter
  def initialize(data_file)
    @data_file = data_file
  end

  def import!
    consume_data do |row|
      hostname = extract_hostname_from_row(row)
      next if ignore_hostname?(hostname)
      host = hosts[hostname]
      if host.nil?
        $stderr.puts "ERROR: Host missing #{hostname}, can't import #{row.inspect}"
      else
        import_row_for_host(host, row)
      end
    end
  end

  def extract_hostname_from_row(row)
    row[:host]
  end

  def create_or_update_object_from_row(parent, row)
    update_object(fetch_object_scope(parent, row).build, row)
  rescue ActiveRecord::RecordNotUnique
    update_object(fetch_object_scope(parent, row).first, row)
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

  def csv_reader(data_file, options = {})
    CSV.new(File.open(data_file), { headers: true,
                                    converters: [:numeric, :date],
                                    header_converters: :symbol,
                                    col_sep: "\t" }.merge(options))
  end

  def consume_data_file(data_file, csv_options = {})
    csv_reader(data_file, csv_options).each do |row|
      yield row
    end
  end
end
