require 'csv'
require 'host_based_importer'
class HitsImporter < HostBasedImporter
  def import!
    Hit.leave_uniqueness_check_to_db = true
    super
  end

  def ignore_hostname?(hostname)
    hostname =~ /^aka/
  end

  def import_row_for_host(host, hit_row)
    result = create_or_update_object_from_row(host, hit_row)
    if result[:ok]
      $stdout.print '.'
    else
      $stdout.print 'F'
      $stderr.puts "ERROR: Can't import #{hit_row.inspect}, #{result[:hit].errors.full_messages}"
    end
  end

  def fetch_object_scope(host, hit_row)
    Hit.where(host_id: host.id, path: hit_row[:path], http_status: hit_row[:status], hit_on: hit_row[:date])
  end

  def update_object(hit, hit_row)
    hit.count = hit_row[:count]
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
end