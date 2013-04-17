class DashboardController < ApplicationController
  layout "application.html.erb"

  def index
    orgs = Organisation.includes(:sites => :hosts)
    today = Time.now.change(:hour => 0)
    @forthcoming_organisations = orgs.order("launch_date asc").where("launch_date >= ?", today)
    @already_live_organisations = orgs.order("launch_date desc").where("launch_date < ?", today)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organisations }
    end
  end
end
