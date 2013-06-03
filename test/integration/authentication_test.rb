require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest

  setup do
    User.delete_all
    ENV['GDS_SSO_MOCK_INVALID'] = '1'
  end

  test "should use GDS SSO to authenticate" do
    get root_path
    assert_redirected_to "/auth/gds"
  end

  test "should allow access when already logged in" do
    login_as_admin
    get root_path
    assert_response :success
  end

  test "should allow logged in users to log out" do
    o = FactoryGirl.create(:organisation)
    login_as_admin
    get organisation_path(o)
    assert_select "a[href=?]", "/auth/gds/sign_out"
  end
end
