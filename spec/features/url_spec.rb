require 'features/features_helper'

feature 'Viewing and editing urls for a site' do
  let(:organisation) { site.organisation }
  let(:site) { host.site }

  let!(:host) { create :natural_england_host }

  let!(:first_url) { create :url, url: 'http://www.naturalengland.org.uk/site', site: site }
  let!(:selected_url) { create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: site }
  let(:middle_url) { selected_url }
  let!(:last_url) { create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: site }

  background do
    login_as_stub_user
  end

  scenario 'Visiting the urls index pre-selects the first url' do
    visit site_urls_path(site)

    page.should have_link('DFID', href: organisation_path(organisation))

    page.should have_list_in_this_order '.urls',
      ['/site', '/about_us/default.aspx', '/contact_us']
    page.should_not have_link(first_url.url)
    page.should have_link(middle_url.url, href: site_url_path(site, middle_url))
    page.should have_link(last_url.url, href: site_url_path(site, last_url))
  end

  scenario "Visiting a single highlighted url's page when there are URLs" do
    visit site_url_path(site, selected_url)

    page.should have_link('DFID', href: organisation_path(organisation))

    page.should have_list_in_this_order('.urls',
      ['/site', '/about_us/default.aspx', '/contact_us'])

    page.should have_link(first_url.url, href: site_url_path(site, first_url))
    page.should_not have_link(selected_url.url)
    page.should have_link(last_url.url, href: site_url_path(site, last_url))

    page.should have_an_iframe_for(selected_url.url)

    # There are no selected buttons or links
    page.should_not have_button('.selected')
    page.should_not have_link('.selected')
  end

  scenario 'Marking a URL as unfinished' do
    visit site_url_path(site, first_url)

    within '.controls' do
      click_button 'Save for review later'
    end

    # Go back to the url we just marked unfinished
    click_link(first_url.url, exact: true)

    # The first URL should be marked as unfinished and be selected
    page.should have_selector('.urls li.unfinished.selected')

    # The unfinished button should be selected
    page.should have_selector('button.unfinished.selected')
  end

  scenario 'Marking a URL as finished' do
    visit site_url_path(site, selected_url)

    within '.controls' do
      click_button 'Save as final'
    end

    # The first URL (which is now previous) is marked finished
    page.should have_link(first_url.url)

    # We should have a selected URL
    page.should have_selector('.urls li.selected')
  end

  scenario "Marking a URL unfinished, setting guidance, series and user need, adding a comment and setting scrape to 'Yes'" do
    create :url_group, name: 'Bee Health', organisation: organisation, url_group_type: create(:url_group_type, name: 'Guidance')
    create :url_group, name: 'Series 1', organisation: organisation, url_group_type: create(:url_group_type, name: 'Series')
    create :user_need, name: 'I need to renew my passport'
    visit site_url_path(site, first_url)

    select 'Bee Health', from: 'url[guidance_id]'
    select 'Series 1', from: 'url[series_id]'
    select 'I need to renew my passport', from: 'url[user_need_id]'
    fill_in 'url_comments', with: 'This could be either MS or IG'
    choose 'Yes'
    click_button 'Save for review later'

    # Go back to the url we just marked unfinished
    click_link(first_url.url, exact: true)

    # The first URL should be marked unfinished and be selected
    page.should have_selector('.urls li.unfinished.selected')

    # The unfinished button should be selected
    page.should have_selector('button.unfinished.selected')
    page.should have_select('url[guidance_id]', selected: 'Bee Health')
    page.should have_select('url[series_id]', selected: 'Series 1')
    page.should have_select('url[user_need_id]', selected: 'I need to renew my passport')
    page.should have_checked_field('Yes')
    page.should have_field('url_comments', with: 'This could be either MS or IG')
  end

  scenario "Selecting content type sets guidance dropdown to readonly or editable depending on content type", js: true do
    create :content_type, type: 'Policy Team', subtype: nil, mandatory_guidance: false
    create :content_type, type: 'Publication', subtype: 'Guidance', mandatory_guidance: true
    create :url_group, name: 'Bee Health', organisation: organisation, url_group_type: create(:url_group_type, name: 'Guidance')
    visit site_url_path(site, first_url)

    page.should have_readonly_select('url[guidance_id]')

    select 'Guidance', from: 'url[content_type_id]'
    page.should have_non_readonly_select('url[guidance_id]')
    select 'Bee Health', from: 'url[guidance_id]'

    select 'Policy Team', from: 'url[content_type_id]'
    # guidance dropdown should be readonly and reset to nil
    page.should have_readonly_select('url[guidance_id]')
    page.should have_select('url[guidance_id]', selected: '')
  end

  scenario "Selecting content type sets document series dropdown to readonly or editable depending on content type", js: true do
    create :content_type, type: 'Policy Team', subtype: nil, scrapable: false
    create :content_type, type: 'Publication', subtype: 'Guidance', scrapable: true
    create :url_group, name: 'Series 1', organisation: organisation, url_group_type: create(:url_group_type, name: 'Series')
    visit site_url_path(site, first_url)

    page.should have_readonly_select('url[series_id]')

    select 'Guidance', from: 'url[content_type_id]'
    page.should have_non_readonly_select('url[series_id]')
    select 'Series 1', from: 'url[series_id]'

    select 'Policy Team', from: 'url[content_type_id]'
    # document series dropdown should be readonly and reset to nil
    page.should have_readonly_select('url[series_id]')
    page.should have_select('url[series_id]', selected: '')
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
