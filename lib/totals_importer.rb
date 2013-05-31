require 'csv'
require 'host_based_importer'
class TotalsImporter < HostBasedImporter

  def ignore_hostname?(hostname)
    hostname =~ /^aka/
  end

  def import_row_for_host(host, total_row)
    result = create_or_update_object_from_row(host, total_row)
    unless result[:ok]
      $stderr.puts "ERROR: Can't import #{total_row.inspect}, #{result[:total].errors.full_messages}"
    end
  end

  def fetch_object_scope(host, total_row)
    Total.where(host_id: host.id, http_status: total_row[:status], total_on: total_row[:date])
  end

  def update_object(total, total_row)
    total.count = total_row[:count]
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
end
