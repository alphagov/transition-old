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

  def update
    destiny = params[:destiny].to_sym
    url = Url.find_by_id(params[:id])
    case destiny
      when :manual
        url.manual!(params[:new_url])
      else
        url.workflow_state = destiny
    end
    url.save!

    redirect_to organisation_url_path(url.site.organisation, url.next)
  end
end