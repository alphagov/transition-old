require 'csv'
require 'uri'
require 'host_based_importer'
class MappingsImporter
  class Base < HostBasedImporter
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
    
    def fetch_object_scope(site, mapping_row)
      Mapping.where(site_id: site.id, path: mapping_row[:old_url][:path])
    end

    def update_mapping_from_row(mapping, mapping_row)
      mapping.http_status = mapping_row[:status]
      mapping.new_url = mapping_row[:new_url]
      mapping.suggested_url = mapping_row[:suggested_link]
      mapping.archive_url = mapping_row[:archive_link]
    end

    def update_object(mapping, mapping_row)
      update_mapping_from_row(mapping, mapping_row)
      {ok: mapping.save, object: mapping}
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

  class Fast < Base
    def consume_data_file(*args)
      @mappings_to_import = []
      super
      $stdout.print "Importing."
      Mapping.import @mappings_to_import, validate: true
      $stdout.puts ".done!"
    end

    def import_row_for_host(host, mapping_row)
      if host.site.nil?
        $stdout.print 'E'
        $stderr.puts "ERROR: Host has no site #{hostname}, can't import #{mapping_row.inspect}"
      else
        $stdout.print '.'
        mapping_for_row = fetch_object_scope(host.site, mapping_row).build
        update_mapping_from_row(mapping_for_row, mapping_row)
        mapping_for_row.prep_for_import
        @mappings_to_import << mapping_for_row
      end
    end
  end

  class Robust < Base
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
          $stderr.puts "ERROR: Can't import #{mapping_row.inspect}, #{result[:object].errors.full_messages}"
        end
      end
    end
  end
end