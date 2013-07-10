require 'features/features_helper'

feature "View all urls and a single url for a site" do
  before do
    login_as_stub_user
    @organisation = create :organisation, title: 'DFID'
    @site = create :site, organisation: @organisation
    @site2 = create :site, organisation: @organisation, site: 'site-2'
    @url1 = create :url, url: 'http://www.naturalengland.org.uk/', site: @site
    @url2 = create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: @site
    @url3 = create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: @site
    @url4 = create :url, url: 'http://www.natural.org.uk/contact_us', site: @site2
  end

  scenario "All Urls for a site" do
    visit site_urls_path(@site)

    page.should have_link('DFID', href: organisation_path(@organisation))
    should_have_list '.urls',
      ['http://www.naturalengland.org.uk/',
       'http://www.naturalengland.org.uk/about_us/default.aspx',
       'http://www.naturalengland.org.uk/contact_us']
    [@url1, @url2, @url3].each {|url| page.should have_link(url.url, href: site_url_path(@site, url))}
  end

  scenario "A single highlighted Url with iframe" do
    visit site_url_path(@site, @url2)

    page.should have_link('DFID', href: organisation_path(@organisation))
    should_have_list '.urls',
      ['http://www.naturalengland.org.uk/',
       'http://www.naturalengland.org.uk/about_us/default.aspx',
       'http://www.naturalengland.org.uk/contact_us']
    page.should have_link(@url1.url, href: site_url_path(@site, @url1))
    page.should_not have_link(@url2.url)
    page.should have_link(@url3.url, href: site_url_path(@site, @url3))
    page.should have_xpath("//iframe[@src='#{@url2.url}']")
  end
end
