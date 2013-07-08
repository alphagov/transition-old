class UrlsController < ApplicationController

  def index
    @organisation = Organisation.find_by_abbr(params[:organisation_id])
    @urls = @organisation.urls.order(:site_id, :id)

    respond_to do |format|
      format.html
      format.json { render json: @urls }
    end
  end

  def show
    @organisation = Organisation.find_by_abbr(params[:organisation_id])
    @url = @organisation.urls.find_by_id(params[:id])
  end
end