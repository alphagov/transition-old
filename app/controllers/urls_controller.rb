class UrlsController < ApplicationController
  layout 'frontend'

  before_filter :find_site

  def index
    @urls = url_filter(@site.urls)
    @url = @urls.first
    flash.now[:error] = 'No Urls were found' if @url.nil?
    render 'show'
  end

  def show
    @urls = url_filter(@site.urls)
    @url = @urls.find_by_id(params[:id])
    if @url.nil?
      @url = url_filter(@site.urls).first
      redirect_to site_url_path(@site, @url, content_type: params[:content_type]) and return if @url
    end
    flash.now[:error] = 'No Urls were found' if @url.nil?
  end

  def update
    destiny = params[:destiny].try(:to_sym)
    @url = @site.urls.find(params[:id])
    @url.state = destiny if destiny
    @url.set_mapping_url(params[:new_url]) if params[:new_url]
    if @url.update_attributes(params[:url])
      redirect_to site_url_path(@url.site, @url.next(url_filter(@site.urls)), content_type: params[:content_type])
    else
      @urls = url_filter(@site.urls)
      render 'show'
    end
  end

  protected

  def url_filter(urls)
    urls = urls.where(content_type_id: params[:content_type]) if params[:content_type].present?
    urls
  end
end
