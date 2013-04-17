class DashboardController < ApplicationController
  layout "application.html.erb"

  def index
    orgs = Organisation.includes(:sites => :hosts)
    @forthcoming_organisations = orgs.order("launch_date asc").where("launch_date >= ?", Time.now)
    @already_live_organisations = orgs.order("launch_date desc").where("launch_date < ?", Time.now)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organisations }
    end
  end
end
