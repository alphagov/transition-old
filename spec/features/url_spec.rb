require 'features/features_helper'

feature "View url for an organisation" do
  before do
    login_as_stub_user
    @organisation = create :organisation, title: 'DFID'
    @site = create :site, organisation: @organisation
    @url1 = create :url, url: 'http://www.naturalengland.org.uk/', site: @site
    @url2 = create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: @site
    @url3 = create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: @site
  end

  scenario "Url page with adjacent urls and iframe" do
    visit organisation_url_path(@organisation, @url2)

    page.should have_link('DFID', href: organisation_path(@organisation))

    page.should have_link(@url1.url, href: organisation_url_path(@organisation, @url1))
    page.should_not have_link(@url2.url)
    page.should have_link(@url3.url, href: organisation_url_path(@organisation, @url3))
    page.should have_xpath("//iframe[@src='#{@url2.url}']")
  end
end
