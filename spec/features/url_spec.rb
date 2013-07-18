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

  scenario "Marking a URL unsure, setting a url group and user need, adding a comment and setting scrape to 'Yes'" do
    create :url_group, name: 'Bee Health', organisation: organisation, url_group_type: create(:url_group_type, name: 'Guidance')
    create :user_need, name: 'I need to renew my passport'
    visit site_url_path(site, first_url)

    select 'Bee Health', from: 'url[url_group_id]'
    select 'I need to renew my passport', from: 'url[user_need_id]'
    fill_in 'url_comments', with: 'This could be either MS or IG'
    choose 'Yes'
    click_button 'Unsure'

    # Go back to the url we just marked manual
    click_link(first_url.url, exact: true)

    # The first URL should be marked unsure and be selected
    page.should have_selector('.urls li.unsure.selected')

    # The unsure button should be selected
    page.should have_selector('button.unsure.selected')
    page.should have_select('url[url_group_id]', selected: 'Bee Health')
    page.should have_select('url[user_need_id]', selected: 'I need to renew my passport')
    page.should have_checked_field('Yes')
    page.should have_field('url_comments', with: 'This could be either MS or IG')
  end

  scenario "Selecting content type sets user need dropdown to readonly or editable depending on content type", js: true do
    create :content_type, type: 'Policy Team', subtype: nil, user_need_required: false
    create :content_type, type: 'Publication', subtype: 'Guidance', user_need_required: true
    create :user_need, name: 'I need to renew my passport'
    visit site_url_path(site, first_url)

    page.should have_readonly_select('url[user_need_id]')

    select 'Guidance', from: 'url[content_type_id]'
    page.should have_non_readonly_select('url[user_need_id]')
    select 'I need to renew my passport', from: 'url[user_need_id]'

    select 'Policy Team', from: 'url[content_type_id]'
    # user needs dropdown should be readonly and reset to nil
    page.should have_readonly_select('url[user_need_id]')
    page.should have_select('url[user_need_id]', selected: '')
  end

  scenario 'showing/hiding the scrape box as we select scrapable/unscrapable content', js: true do
    scrapable_type = create :content_type
    unscrapable_type = create :unscrapable_content_type

    visit site_url_path(site, first_url)

    page.should_not have_selector('.column-3 .scrape')

    select scrapable_type.subtype, from: 'url[content_type_id]'
    page.should have_selector('.column-3 .scrape')

    select unscrapable_type.subtype, from: 'url[content_type_id]'
    page.should_not have_selector('.column-3 .scrape')
  end
end


