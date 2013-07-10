require 'features/features_helper'

feature 'Viewing a url for a site' do
  let(:organisation) { site.organisation }
  let(:site) { host.site }

  let!(:host) { create :natural_england_host }

  let!(:first_url) { create :url, url: 'http://www.naturalengland.org.uk/', site: site }
  let!(:selected_url) { create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: site }
  let(:middle_url) { selected_url }
  let!(:last_url) { create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: site }

  background do
    login_as_stub_user
  end

  scenario 'Visiting all URLs for a site' do
    visit site_urls_path(site)

    page.should have_link('DFID', href: organisation_path(organisation))

    page.should have_list_in_this_order '.urls',
                                        ['http://www.naturalengland.org.uk/',
                                         'http://www.naturalengland.org.uk/about_us/default.aspx',
                                         'http://www.naturalengland.org.uk/contact_us']

    [first_url, middle_url, last_url].each { |url| page.should have_link(url.url, href: site_url_path(site, url)) }
  end

  scenario "Visiting a single highlighted url's page when there are URLs" do
    visit site_url_path(site, selected_url)

    page.should have_link('DFID', href: organisation_path(organisation))

    page.should have_list_in_this_order(
                    '.urls',
                    ['http://www.naturalengland.org.uk/',
                     'http://www.naturalengland.org.uk/about_us/default.aspx',
                     'http://www.naturalengland.org.uk/contact_us']
                )

    page.should have_link(first_url.url, href: site_url_path(site, first_url))
    page.should_not have_link(selected_url.url)
    page.should have_link(last_url.url, href: site_url_path(site, last_url))

    page.should have_an_iframe_for(selected_url.url)

    # There are no selected buttons or links
    page.should_not have_button('.selected')
    page.should_not have_link('.selected')
  end

  scenario 'Marking a URL manual without a new URL' do
    visit site_url_path(site, selected_url)

    within '.controls' do
      click_button 'Manual'
    end

    # The first URL (which is now previous) is marked manual
    page.should have_link(first_url.url)

    # We should have a selected URL
    page.should have_selector('.urls li.selected')
  end

  scenario 'Marking a URL manual with a new URL' do
    visit site_url_path(site, first_url)

    within '.controls' do
      fill_in 'new_url', with: 'http://somewhere.com'
      click_button 'Manual'
    end

    # Go back to the url we just marked manual
    click_link(first_url.url, exact: true)

    # The first URL should be marked manual and be selected
    page.should have_selector('.urls li.manual.selected')

    # The manual button should be selected
    page.should have_selector('button.manual.selected')
  end
end
