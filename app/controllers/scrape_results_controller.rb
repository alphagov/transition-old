class ScrapeResultsController < ApplicationController
  layout 'frontend'

  before_filter :find_site

  def new
    @url = @site.urls.scrapable.find(params[:url_id])
    # cater for scrape result already existing
    if @url.scrape_result
      redirect_to edit_site_scrape_result_path(@site, @url.scrape_result, url_id: @url)
    end
    @scrape_result = ScrapeResult.new
  end

  def create
    @url = @site.urls.scrapable.find(params[:url_id])
    @url.build_scrape_result(data: params[:scrape_result].to_json)
    @url.scrape_result.save!
    @url.update_attribute(:scrape_finished, true) if params[:button] == 'finished'
    redirect_to edit_site_scrape_result_path(@site, @url.scrape_result, url_id: @url)
  end

  def edit
    @url = @site.urls.scrapable.find(params[:url_id])
    @scrape_result = @url.scrape_result
  end

  def update
    @url = @site.urls.scrapable.find(params[:url_id])
    @scrape_result = @url.scrape_result.update_attributes!(data: params[:scrape_result].to_json)
    @url.update_attribute(:scrape_finished, true) if params[:button] == 'finished'
    redirect_to edit_site_scrape_result_path(@site, @url.scrape_result, url_id: @url)
  end
end
