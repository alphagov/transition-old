require 'csv'
require 'uri'
class MappingsImporter
  def initialize(data_file)
    @data_file = data_file
  end

  def import!
    Mapping.leave_uniqueness_check_to_db = true
    consume_data do |mapping_row|
      host = hosts[mapping_row[:old_url][:host]]
      if host.nil?
        $stdout.print 'E'
        $stderr.puts "ERROR: Host missing #{hostname}, can't import #{mapping_row.inspect}"
      elsif host.site.nil?
        $stdout.print 'E'
        $stderr.puts "ERROR: Host has no site #{hostname}, can't import #{mapping_row.inspect}"
      else
        result = create_or_update_mapping_for_site_from_row(host.site, mapping_row)
        if result[:ok]
          $stdout.print '.'
        else
          $stdout.print 'F'
          $stderr.puts "ERROR: Can't import #{mapping_row.inspect}, #{result[:mapping].errors.full_messages}"
        end
      end
    end
  end

  def fetch_mapping_scope(site, mapping_row)
    Mapping.where(site_id: site.id, path: mapping_row[:old_url][:path])
  end

  def create_or_update_mapping_for_site_from_row(site, mapping_row)
    update_mapping(fetch_mapping_scope(site, mapping_row).build, mapping_row)
  rescue ActiveRecord::RecordNotUnique
    update_mapping(fetch_mapping_scope(site, mapping_row).first, mapping_row)
  end

  def update_mapping(mapping, mapping_row)
    mapping.http_status = mapping_row[:status]
    mapping.new_url = mapping_row[:new_url]
    mapping.suggested_url = mapping_row[:suggested_link]
    mapping.archive_url = mapping_row[:archive_link]
    {ok: mapping.save, mapping: mapping}
  end

  def hosts
    @hosts ||= Host.includes(:site).all.inject({}) { |m, h| m.merge(h.host => h) }
  end

  def consume_data(&block)
    Dir[@data_file].each do |data_file|
      $stdout.puts "Processing: #{data_file}"
      consume_data_file(data_file, &block)
      $stdout.puts "\n"
    end
  end

  def consume_data_file(data_file)
    csv = CSV.new(File.open(data_file), { headers: true,
                                          converters: [:numeric, :date],
                                          header_converters: :symbol,
                                          col_sep: "," })
    csv.convert do |field, field_info|
      if field_info.header == :old_url
        out = {full: field}
        u = URI.parse(field)
        out[:host] = u.host
        out[:path] = u.request_uri
        out[:path] += "##{u.fragment}" unless u.fragment.blank?
        out
      else
        field
      end
    end
    csv.each do |hit_row|
      yield hit_row
    end
  end


end