require 'features/features_helper'

feature 'View url for an organisation' do
  let!(:organisation) { create :organisation, title: 'DFID' }

  let!(:site)         { create :site, organisation: organisation }

  let!(:first_url)    { create :url, url: 'http://www.naturalengland.org.uk/', site: site }
  let!(:selected_url) { create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: site }
  let!(:last_url)     { create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: site }

  background do
    login_as_stub_user
  end

  scenario 'Visiting the url page when there are URLs' do
    visit site_url_path(site, selected_url)

    page.should have_link('DFID', href: organisation_path(organisation))

    page.should     have_link(first_url.url, href: site_url_path(site, first_url))
    page.should_not have_link(selected_url.url)
    page.should     have_link(last_url.url, href: site_url_path(site, last_url))

    page.should have_an_iframe_at(selected_url.url)
  end
end
