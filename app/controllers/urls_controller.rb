class UrlsController < ApplicationController
  def index
    if params[:site_id]
      @site = Site.find_by_site!(params[:site_id])
      @organisation = @site.organisation
    else
      @organisation = Organisation.find_by_abbr!(params[:organisation_id])
    end

    @url_org = @site || @organisation
    @urls = @url_org.urls.order(:site_id, :id)

    respond_to do |format|
      format.html
      format.json { render json: @urls }
    end
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