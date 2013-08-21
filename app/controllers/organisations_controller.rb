class OrganisationsController < ApplicationController

  # GET /organisations
  # GET /organisations.json
  def index
    today = Time.now.change(:hour => 0)

    orgs = Organisation.includes(:sites => :hosts)
    @forthcoming_organisations = orgs.order("launch_date asc").where("launch_date >= ?", today)
    @already_live_organisations = orgs.order("launch_date desc").where("launch_date < ?", today)
    @organisations = []
    @organisations << ["forthcoming", @forthcoming_organisations] if @forthcoming_organisations.length > 0
    @organisations << ["live", @already_live_organisations] if @already_live_organisations.length > 0

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: orgs }
    end
  end

  # GET /organisations/1
  # GET /organisations/1.json
  def show
    @organisation = Organisation.find_by_abbr(params[:id])
    @counts = @organisation.summarise_url_state
    @total_urls = @counts.values.inject(0) {|sum, n| sum + n}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organisation }
    end
  end

  # GET /organisations/new
  # GET /organisations/new.json
  def new
    @organisation = Organisation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organisation }
    end
  end

  # GET /organisations/1/edit
  def edit
    @organisation = Organisation.find_by_abbr(params[:id])
  end

  # POST /organisations
  # POST /organisations.json
  def create
    @organisation = Organisation.new(params[:organisation])

    respond_to do |format|
      if @organisation.save
        format.html { redirect_to @organisation, notice: 'Organisation was successfully created.' }
        format.json { render json: @organisation, status: :created, location: @organisation }
      else
        format.html { render action: "new" }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organisations/1
  # PUT /organisations/1.json
  def update
    @organisation = Organisation.find_by_abbr(params[:id])

    respond_to do |format|
      if @organisation.update_attributes(params[:organisation])
        format.html { redirect_to @organisation, notice: 'Organisation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.json
  def destroy
    @organisation = Organisation.find_by_abbr(params[:id])
    @organisation.destroy

    respond_to do |format|
      format.html { redirect_to organisations_url }
      format.json { head :no_content }
    end
  end
end
