class UrlsController < ApplicationController
  layout 'frontend'

  before_filter :find_site

  def index
    @url = @site.urls.first
    if @url.nil?
      render 'no_urls'
    else
      render 'show'
    end
  end

  def show
    @url = @site.urls.find(params[:id])
  end

  def update
    destiny = params[:destiny].try(:to_sym)
    @url = @site.urls.find(params[:id])
    @url.state = destiny if destiny
    @url.set_mapping_url(params[:new_url]) if params[:new_url]
    if @url.update_attributes(params[:url])
      redirect_to site_url_path(@url.site, @url.next)
    else
      render 'show'
    end
  end
end