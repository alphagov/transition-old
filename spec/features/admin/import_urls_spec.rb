require 'features/features_helper'

feature "Import urls for a given site" do
  before do
    login_as_stub_user
    @organisation = create :organisation, title: 'DFID'
    @site1 = create :site, organisation: @organisation, site: 'DFID-site1'
    @site2 = create :site, organisation: @organisation, site: 'DFID-site2'
  end

  scenario "Import urls page should have a site dropdown and a file upload button" do
    visit admin_import_path(@organisation)

    page.should have_select('Site')
    page.should have_field('file')

    click_button 'Upload'

    page.should have_content('Site needs to be selected and CSV file needs to be selected')
  end
end
