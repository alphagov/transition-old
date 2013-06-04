class MappingsController < ApplicationController

  def index
    @site = Site.find_by_site(params[:site_id])
    @organisation = @site.organisation
    @mappings = @site.mappings.order(:path)
    @host = @site.default_host

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sites }
    end
  end

end

