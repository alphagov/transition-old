ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActionDispatch::IntegrationTest
  include FactoryGirl::Syntax::Methods

  def login_as(user)
    GDS::SSO.test_user = user
  end

  def login_as_admin
    login_as(create(:user, name: "user-name", email: "user@example.com"))
  end

  teardown do
    GDS::SSO.test_user = nil
  end
end
