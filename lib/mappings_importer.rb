require 'csv'
require 'uri'
require 'host_based_importer'
class MappingsImporter < HostBasedImporter

  def import!
    Mapping.leave_uniqueness_check_to_db = true
    super
  end

  def ignore_hostname?(hostname)
    false
  end

  def extract_hostname_from_row(row)
    row[:old_url][:host]
  end

  def import_row_for_host(host, mapping_row)
    if host.site.nil?
      $stdout.print 'E'
      $stderr.puts "ERROR: Host has no site #{hostname}, can't import #{mapping_row.inspect}"
    else
      result = create_or_update_object_from_row(host.site, mapping_row)
      if result[:ok]
        $stdout.print '.'
      else
        $stdout.print 'F'
        $stderr.puts "ERROR: Can't import #{mapping_row.inspect}, #{result[:mapping].errors.full_messages}"
      end
    end
  end

  def fetch_object_scope(site, mapping_row)
    Mapping.where(site_id: site.id, path: mapping_row[:old_url][:path])
  end

  def update_object(mapping, mapping_row)
    mapping.http_status = mapping_row[:status]
    mapping.new_url = mapping_row[:new_url]
    mapping.suggested_url = mapping_row[:suggested_link]
    mapping.archive_url = mapping_row[:archive_link]
    {ok: mapping.save, mapping: mapping}
  end

  def csv_reader(data_file, options)
    csv = super(data_file, options.merge(col_sep: ','))
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
    csv
  end

end