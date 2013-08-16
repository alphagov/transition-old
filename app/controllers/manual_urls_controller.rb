class ManualUrlsController < ApplicationController
  include Transition::Controllers::ReadOnlyFilter

  layout 'frontend'

  before_filter :find_site

  def index
    @urls = @site.urls.manual.final.order(:id)
    flash.now[:error] = 'No Urls were found' if @urls.empty?
  end

  def update
    @url = @site.urls.manual.find(params[:id])
    mapping = @url.set_mapping_url(params["mapping_url_#{@url.id}"])
    render json: { model: @url.mapping.as_json(except: [:created_at, :updated_at]), errors: mapping.errors.full_messages }
  end
end
