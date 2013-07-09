require 'features/features_helper'

feature "List of urls for an organisation and site" do
  before do
    login_as_stub_user
    @organisation = create :organisation, title: 'DFID'
    @site = create :site, organisation: @organisation
    @url = create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: @site
  end

  scenario "Urls under organisation" do
    visit organisation_urls_path(@organisation)
    page.should have_link('DFID', href: organisation_path(@organisation))

    page.should have_link(@url.url, href: site_url_path(@site, @url))
  end

  scenario "Urls under site" do
    visit site_urls_path(@site)
    page.should have_link('DFID', href: organisation_path(@organisation))

    page.should have_link(@url.url, href: site_url_path(@site, @url))
  end
end