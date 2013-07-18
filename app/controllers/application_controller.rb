class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods

  before_filter :require_signin_permission!

  protect_from_forgery

  def error_400; error 400; end
  def error_404; error 404; end

  rescue_from ActiveRecord::RecordNotFound, with: :error_404

  protected

  def find_site
    @site = Site.find_by_site!(params[:site_id])
  end

  private

  def error(status_code)
    render status: status_code, text: "#{status_code} error"
  end
end
