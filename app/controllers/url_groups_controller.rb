class UrlGroupsController < ApplicationController
  include Transition::Controllers::ReadOnlyFilter

  def create
    @url_group = UrlGroup.new(params[:url_group])
    @url_group.save
    render json: {model: @url_group.as_json(except: [:created_at, :updated_at]), errors: @url_group.errors.full_messages}
  end
end
