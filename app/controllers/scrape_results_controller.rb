class ScrapeResultsController < ApplicationController
  layout 'frontend'

  before_filter :find_site

  def new
    @url = @site.urls.for_scraping.find(params[:url_id])
    # cater for scrape result already existing
    if @url.scrape_result
      redirect_to edit_site_scrape_result_path(@site, @url.scrape_result, url_id: @url)
    end
    @scrape_result = ScrapeResult.new
  end

  def create
    @url = @site.urls.for_scraping.find(params[:url_id])
    Url.transaction do
      @url.update_attribute(:scrape_finished, params[:button] == 'finished')
      @url.build_scrape_result(data: params[:scrape_result].to_json)
      if @url.scrape_result.save
        redirect_to edit_site_scrape_result_path(@site, @url.scrape_result, url_id: @url, type: params[:type]) and return
      else
        @scrape_result = @url.scrape_result
        raise ActiveRecord::Rollback
      end
    end
    render 'new'
  end

  def edit
    @url = @site.urls.for_scraping.find(params[:url_id])
    @scrape_result = @url.scrape_result
  end

  def update
    @url = @site.urls.for_scraping.find(params[:url_id])
    Url.transaction do
      @url.update_attribute(:scrape_finished, params[:button] == 'finished')
      @scrape_result = @url.scrape_result
      if @scrape_result.update_attributes(data: params[:scrape_result].to_json)
        redirect_to edit_site_scrape_result_path(@site, @url.scrape_result, url_id: @url, type: params[:type]) and return
      else
        raise ActiveRecord::Rollback
      end
    end
    render 'edit'
  end

  def index
    respond_to do |format|
      format.csv do
        @scrape_results = @site.urls.where(scrape_finished: true).joins(:scrape).includes(:scrape).map { |u| u.scrape }
        @scrape_results.concat ScrapeResult.find_by_url_group_all_scraped(@site)
        render csv: @scrape_results
      end
      format.html do
        if params[:type].blank?
          @content_types_hash = ContentType.for_site(@site).for_scrape.group_by {|content_type| content_type.type}
        else
          @url = @site.urls.for_scraping.for_type(params[:type]).in_scraping_order.first
          @scrape_result = @url.scrape_result || ScrapeResult.new
          render 'new'
        end
      end
    end
  end
end
