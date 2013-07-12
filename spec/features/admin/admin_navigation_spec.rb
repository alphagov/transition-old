require 'features/features_helper'

feature "Navigate from the main site to the admin site and back again" do
  before do
    login_as_stub_user
  end

  scenario "A user can navigate to the admin section and back again" do
    visit root_path
    click_link 'Admin'

    page.current_path.should == admin_root_path
    page.should have_link('Import URLs')
    click_link 'GOV.UK Transition'

    page.current_path.should == root_path
  end
end
