class UrlsController < ApplicationController
  layout 'frontend'

  def index
    @site = Site.find_by_site!(params[:site_id])
    @organisation = @site.organisation
  end

  def show
    @site = Site.find_by_site!(params[:site_id])
    @organisation = @site.organisation
    @url = @organisation.urls.find(params[:id])
  end

  def update
    destiny = params[:destiny].to_sym
    url = Url.find(params[:id])
    case destiny
      when :manual
        url.manual!(params[:new_url])
      else
        url.workflow_state = destiny
    end
    url.save!

    redirect_to site_url_path(url.site, url.next)
  end
end