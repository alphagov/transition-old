class PagesController < ApplicationController

  def index
    @orgs = Organisation.gds_manages_redirects.with_counts.order("launch_date asc")
  end

  def show
    @organisation = Organisation.find_by_abbr!(params[:id])
    if @organisation.sites.count == 1
      @site = @organisation.sites.first
      @obj = @site
    elsif params[:site] && params[:site] != ''
      @site = Site.find_by_id(params[:site])
      @obj = @site
    end
    if @site && @site.hosts.count == 1
      @host = @site.hosts.first
      @obj = @host
    elsif params[:host] && params[:host] != ''
      @host = Host.find_by_id(params[:host])
      @obj = @host
    end
    if @obj.nil?
      @obj = @organisation
    end
    @total_data = WeeklyTotalData.new(@obj.weekly_totals, Date.new(2012,10,17)..Date.today, true)
    if params[:start]
      @start_date = DateTime.strptime(params[:start], '%Y-W%U')
      @end_date = @start_date + 7.days
      @most_recent_hit_data = HitRangeData.new(@obj.hits.includes(:host), @start_date, @end_date)
    else
      if params[:date]
        begin
          @start_date = DateTime.strptime(params[:date], '%Y-%m-%d')
        rescue
          raise ActionController::RoutingError.new('Not Found')
        end
      end
      unless @start_date
        @start_date = @obj.hits.most_recent_hit_on_date
      end
      @most_recent_hit_data = MostRecentHitData.new(@obj.hits.includes(:host), @start_date)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @obj }
    end
  end
end
