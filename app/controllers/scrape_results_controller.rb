class ScrapeResultsController < ApplicationController
  layout 'frontend'

  before_filter :find_site

  def new
    @url = @site.urls.scrapable.find(params[:url_id])
    # cater for scrape result already existing
    if @url.scrape_result
      redirect_to edit_site_scrape_result_path(@site, @url.scrape_result)
    end
    @scrape_result = ScrapeResult.new
  end
end
