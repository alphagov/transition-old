class MappingsController < ApplicationController
  layout 'frontend'

  before_filter :find_site

  def index
    @mappings_data = MappingsData.new(@site.mappings.order(:path))
    @host = @site.default_host

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sites }
    end
  end

  def new
    @mapping = @site.mappings.build
  end

  def create
    @mapping = @site.mappings.build(params[:mapping])
    if @mapping.save
      redirect_to site_mappings_path(@site), notice: "Mapping saved"
    else
      render action: 'new'
    end
  end

  def edit
    @mapping = @site.mappings.find(params[:id])
  end

  def update
    @mapping = @site.mappings.find(params[:id])
    if @mapping.update_attributes(params[:mapping])
      redirect_to site_mappings_path(@site), notice: "Mapping saved"
    else
      render action: 'edit'
    end
  end

  def destroy
    @mapping = @site.mappings.find(params[:id])
    @mapping.destroy
    redirect_to site_mappings_path(@site), notice: "Mapping deleted"
  end

  protected

  def find_site
    @site = Site.find_by_site!(params[:site_id])
  end
  
end
