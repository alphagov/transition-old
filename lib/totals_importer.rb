require 'csv'
require 'host_based_importer'
class TotalsImporter
  class Base < HostBasedImporter
    def ignore_hostname?(hostname)
      hostname =~ /^aka/
    end

    def fetch_object_scope(host, total_row)
      Total.where(host_id: host.id, http_status: total_row[:status], total_on: total_row[:date])
    end

    def update_total_from_row(total, total_row)
      total.count = total_row[:count]
    end

    def update_object(total, total_row)
      update_total_from_row(total, total_row)
      {ok: total.save, object: total}
    end

    def find_or_create_total_for_host_from_row(host, total_row)
      total_scope = fetch_total_scope(host, total_row)
      if total_scope.first.present?
        total_scope.first
      else
        total_scope.build
      end
    end
  end

  class Robust < Base
    def import_row_for_host(host, total_row)
      result = create_or_update_object_from_row(host, total_row)
      unless result[:ok]
        $stderr.puts "ERROR: Can't import #{total_row.inspect}, #{result[:object].errors.full_messages}"
      end
    end
  end

  class Fast < Base
    def consume_data_file(*args)
      @totals_to_import = []
      super
      $stdout.print "Importing."
      Total.import @totals_to_import, validate: true
      $stdout.puts ".done!"
    end

    def import_row_for_host(host, total_row)
      $stdout.print '.'
      total_for_row = fetch_object_scope(host, total_row).build
      update_total_from_row(total_for_row, total_row)
      total_for_row.prep_for_import
      @totals_to_import << total_for_row
    end
  end
end
