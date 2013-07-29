require 'features/features_helper'

feature 'Adding a Guidance or Document Series on a Url page' do
  let(:organisation) { site.organisation }
  let(:site) { host.site }
  let!(:host) { create :natural_england_host }
  let!(:first_url) { create :url, url: 'http://www.naturalengland.org.uk/site', site: site }
  let!(:second_url) { create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: site }
  let!(:guidance) { create :guidance_group_type }
  let!(:series) { create :series_group_type }
  let!(:content_type) { create :detailed_guide_content_type, type: 'Detailed guide' }

  background do
    login_as_stub_user
  end

  scenario 'Adding Guidance', js: true do
    visit site_urls_path(site)

    page.should have_list_in_this_order '.urls',
      ['/site', '/about_us/default.aspx']
    select 'Detailed guide', from: 'url[content_type_id]'
    within(:xpath, '//*[@id="url_guidance_id"]/..') { click_link '+' }

    page.should have_content 'Create Guidance'
    within '#dialog_guidance' do
      fill_in 'url_group_name', with: 'Aloha'
      click_button 'Save'
    end

    page.should_not have_content 'Create Guidance' # dialog has closed
    page.should have_select('url_guidance_id', selected: 'Aloha')

    # check that errors are displayed and cancel link is working
    within(:xpath, '//*[@id="url_guidance_id"]/..') { click_link '+' }
    within '#dialog_guidance' do
      find_field 'url_group_name', with: '' # check that input has been cleared
      fill_in 'url_group_name', with: 'Aloha'
      click_button 'Save'
    end

    page.should have_content 'Create Guidance' # dialog is still open
    within '#dialog_guidance' do
      page.should have_content 'Name has already been taken'
      click_link 'Cancel'
    end

    page.should_not have_content 'Create Guidance' # dialog has closed
  end

  scenario 'Adding Document Series', js: true do
    visit site_urls_path(site)

    page.should have_list_in_this_order '.urls',
      ['/site', '/about_us/default.aspx']
    within(:xpath, '//*[@id="url_series_id"]/..') { click_link '+' }

    page.should have_content 'Create Document Series'
    within '#dialog_series' do
      fill_in 'url_group_name', with: 'Aloha'
      click_button 'Save'
    end

    page.should_not have_content 'Create Document Series' # dialog has closed
    # Aloha is not pre-selected because the Document Series dropdown is readonly
    page.should_not have_select('url_series_id', selected: 'Aloha')
    # but let's check that it has been added to teh dropdown
    select 'Detailed guide', from: 'url[content_type_id]'
    page.should have_select('url_series_id', with_options: ['Aloha'])

    # check that errors are displayed and cancel link is working
    within(:xpath, '//*[@id="url_series_id"]/..') { click_link '+' }
    within '#dialog_series' do
      find_field 'url_group_name', with: '' # check that input has been cleared
      fill_in 'url_group_name', with: 'Aloha'
      click_button 'Save'
    end

    page.should have_content 'Create Document Series' # dialog is still open
    within '#dialog_series' do
      page.should have_content 'Name has already been taken'
      click_link 'Cancel'
    end

    page.should_not have_content 'Create Document Series' # dialog has closed
  end
end
