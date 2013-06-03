class DashboardController < ApplicationController
  layout "dashboard.html.erb"

  def index
    @orgs = Organisation.includes(:sites => :hosts).order("launch_date asc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organisations }
    end
  end
end
