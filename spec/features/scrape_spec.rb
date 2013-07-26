require 'features/features_helper'

feature 'Scraping' do
  let(:organisation) { site1.organisation }
  let(:host) { create :natural_england_host }
  let(:site1) { host.site }
  let(:site2) { create :site, organisation: organisation }

  let!(:content_type1) { create :content_type, type: 'Publishing', subtype: 'Detail'}
  let!(:content_type2) { create :content_type, type: 'Topic', subtype: nil}
  let!(:content_type3) { create :content_type, type: 'News', subtype: nil}
  let!(:url_group) { create :url_group, name: 'Bee health'}
  let!(:url1) { create :url, url: 'http://www.naturalengland.org.uk/', site: site1, for_scraping: true, content_type: content_type2 }
  let!(:url2) { create :url, site: site2, for_scraping: true }
  let!(:url3) { create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: site1, for_scraping: true,
                content_type: content_type1, guidance: url_group, comments: 'Hello'}
  let!(:url4) { create :url, url: 'http://www.naturalengland.org.uk/hello', site: site1, for_scraping: false, content_type: content_type3 }
  let!(:url5) { create :url, url: 'http://www.naturalengland.org.uk/jumping', site: site1, for_scraping: true,
                content_type: content_type1, guidance: url_group}

  background do
    login_as_stub_user
  end

  scenario 'View all content type types for Urls to be scraped and then urls for a specific type' do
    visit site_urls_path(site1)
    click_link 'Scrape'

    page.should have_list_in_this_order 'ul.types', ['Publishing', 'Topic']

    click_link 'Topic'

    page.should have_list_in_this_order 'ul.scrape', ['/ - Topic']    
  end

  scenario 'View a url for scraping that currently has not been scraped and save scrape results first with "Save for later" and then "Save as final"' do
    content_type1.scrapable_fields << create(:scrapable_field_title) << create(:scrapable_field_body, mandatory: true)

    visit site_scrape_results_path(site1)
    click_link 'Publishing'

    page.should have_list_in_this_order '.urls', ['/contact_us - Publishing / Detail - Bee health', '/jumping - Publishing / Detail - Bee health']
    page.should have_content 'Hello'
    page.should have_an_iframe_for(url3.url)

    fill_in 'Title', with: 'Anna Karenina'
    click_button 'Save for later'

    page.should have_field('Title', with: 'Anna Karenina')
    page.should have_field('Body')
    page.should have_no_selector('.urls li.finished', text: '/contact_us')

    click_button 'Save as final'

    page.should have_no_selector('.urls li.finished', text: '/contact_us')
    page.should have_content('Body must be populated before scrape is marked as final')

    fill_in 'Body', with: 'Once upon a time'
    click_button 'Save as final'

    page.should have_field('Body', with: 'Once upon a time')
    page.should have_selector('.urls li.finished', text: '/contact_us')
  end

  scenario 'Create scrape results for urls belonging to the same detailed guide' do
    content_type = create :detailed_guide_content_type
    content_type.scrapable_fields << create(:scrapable_field_title) << create(:scrapable_field_body)
    url5 = create :url, url: 'http://www.naturalengland.org.uk/detailed_guide/1', site: site1, for_scraping: true,
                content_type: content_type, guidance: url_group
    url6 = create :url, url: 'http://www.naturalengland.org.uk/detailed_guide/2', site: site1, for_scraping: true,
                content_type: content_type, guidance: url_group

    visit site_scrape_results_path(site1)
    click_link 'Detailed guide'

    page.should have_list_in_this_order '.urls', 
      ['/detailed_guide/1 - Detailed guide - Bee health', '/detailed_guide/2 - Detailed guide - Bee health']
    fill_in 'Title', with: 'Anna Karenina'
    fill_in 'Body', with: 'Once upon a time'
    click_button 'Save for later'

    visit site_scrape_results_path(site1)
    click_link 'Detailed guide'
    click_link '/detailed_guide/2'

    page.should have_field('Title', with: 'Anna Karenina')
    page.should have_field('Body', with: 'Once upon a time')
  end
end
