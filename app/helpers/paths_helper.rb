module PathsHelper
  def calculate_scrape_result_path(url)
    url.scrape_result ? edit_site_scrape_result_path(url.site, url.scrape_result) : new_site_scrape_result_path(url.site, url_id: url)
  end
end
