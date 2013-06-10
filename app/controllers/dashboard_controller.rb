class DashboardController < ApplicationController
  layout "dashboard"

  def index
    @orgs = Organisation.gds_manages_redirects.with_counts.order("launch_date asc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organisations }
    end
  end
end
