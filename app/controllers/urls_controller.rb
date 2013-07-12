class UrlsController < ApplicationController
  layout 'frontend'

  def index
    @site = Site.find_by_site!(params[:site_id])
  end

  def show
    @site = Site.find_by_site!(params[:site_id])
    @url = @site.urls.find(params[:id])
    @content_types = ContentType.order(:type)
  end

  def update
    destiny = params[:destiny].try(:to_sym)
    url = Url.find(params[:id])
    case destiny
      when :manual
        url.manual!(params[:new_url])
      else
        url.workflow_state = destiny
    end if destiny
    url.update_attributes!(params[:url])

    redirect_to site_url_path(url.site, url.next)
  end
end