require 'http_status_categorization'

class OrganisationData
  include HttpStatusCategorization

  def initialize(organisation)
    @organisation = organisation
  end

  def most_recent_total_on_date
    @most_recent_total_on_date ||= @organisation.aggregated_totals.most_recent_total_on_date(from_aggregate: true)
  end

  def hosts_count
    @hosts_count ||= @organisation.hosts_count
  end

  def sites_count
    @sites_count ||= @organisation.sites_count
  end

  def mappings_count
    @mappings_count ||= @organisation.mappings_count
  end

  def launch_date
    @launch_date ||= @organisation.launch_date
  end

  def most_recent_data
    @most_recent_data ||= @organisation.aggregated_totals.most_recent_totals(most_recent_total_on_date)
  end

  def most_recent_data_grouped_by_http_status_category
    @grouped_by_http_status ||= grouped_by_http_status_category(most_recent_data)
  end

  def totals_by_http_status_category
    @totals_by_http_status ||=
      Hash[ most_recent_data_grouped_by_http_status_category.map { |hsc, data|
        [hsc, data.inject(0) { |sum, x| sum + x.count } ]
      } ]
  end

  def max_total_for_http_status_category(fallback = 0)
    totals_by_http_status_category.values.max || fallback
  end

end