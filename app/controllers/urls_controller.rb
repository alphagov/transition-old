class UrlsController < ApplicationController
  layout 'frontend'

  def index
    @site = Site.find_by_site!(params[:site_id])
    if params[:scrapable] == 'true'
      render 'scrapable_urls' and return
    end
  end

  def show
    @site = Site.find_by_site!(params[:site_id])
    @url = @site.urls.find(params[:id])
  end

  def update
    destiny = params[:destiny].try(:to_sym)
    url = Url.find(params[:id])
    url.workflow_state = destiny if destiny
    url.set_mapping_url(params[:new_url]) if params[:new_url]
    url.update_attributes!(params[:url])

    redirect_to site_url_path(url.site, url.next)
  end
end