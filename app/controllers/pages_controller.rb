class PagesController < ApplicationController
  layout 'frontend'

  def index
  end

  def show
    @organisation = Organisation.find_by_abbr!(params[:id])
    if params[:host]
      @obj = Host.find_by_host(params[:id])
    elsif params[:site]
      @obj = Site.find_by_site(params[:id])
    else
      @obj = @organisation
    end
    @total_data = WeeklyTotalData.new(@obj.weekly_totals, Date.new(2012,10,17)..Date.today)
    @most_recent_hit_data = MostRecentHitData.new(@obj.hits, @obj.hits.most_recent_hit_on_date)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @obj }
    end
  end
end
