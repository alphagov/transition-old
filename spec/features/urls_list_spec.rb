require 'features/features_helper'

feature "List of urls for an organisation" do
  before do
    login_as_stub_user
    @organisation = create :organisation, title: 'DFID'
    @site = create :site, organisation: @organisation
    @url = create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: @site
  end

  scenario "Site urls" do
    visit organisation_urls_path(@organisation)
    page.should have_link('DFID', href: organisation_path(@organisation))

    page.should have_link(@url.url, href: organisation_url_path(@organisation, @url))
  end
end