require 'features/features_helper'

feature "View Organisation page with associated sites" do
  before do
    login_as_stub_user
    @organisation = create :organisation, title: 'DFID'
    @site1 = create :site, organisation: @organisation, site: 'DFID-site1'
    @site2 = create :site, organisation: @organisation, site: 'DFID-site2'
  end

  scenario "Organisation page should have links to site urls" do
    visit organisation_path(@organisation)

    page.should have_content('DFID')
    page.should have_link('Analysis', href: site_urls_path(@site1))
    page.should have_link('Analysis', href: site_urls_path(@site2))
  end
end
