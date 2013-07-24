module PathsHelper
  def calculate_scrape_result_path(url)
    if url.scrape_result
      edit_site_scrape_result_path(url.site, url.scrape_result, url_id: url, type: params[:type])
    else
      new_site_scrape_result_path(url.site, url_id: url, type: params[:type])
    end
  end
end
