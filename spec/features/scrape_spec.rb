require 'features/features_helper'

feature 'Scraping' do
  let(:organisation) { site1.organisation }
  let(:host) { create :natural_england_host }
  let(:site1) { host.site }
  let(:site2) { create :site, organisation: organisation }

  let!(:content_type1) { create :content_type, type: 'Publishing', subtype: 'Detail'}
  let!(:content_type2) { create :content_type, type: 'Topic', subtype: nil}
  let!(:url_group) { create :url_group, name: 'Bee health'}
  let!(:url1) { create :url, url: 'http://www.naturalengland.org.uk/', site: site1, is_scrape: true, content_type: content_type2 }
  let!(:url2) { create :url, site: site2, is_scrape: true }
  let!(:url3) { create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: site1, is_scrape: true, 
                content_type: content_type1, url_group: url_group, comments: 'Hello'}
  let!(:url4) { create :url, url: 'http://www.naturalengland.org.uk/hello', site: site1, is_scrape: false }

  background do
    login_as_stub_user
  end

  scenario 'View all urls for a site needing to be scraped' do
    visit site_urls_path(site1)
    click_link 'Scrape'

    page.should have_exact_table 'table thead', [
      ['Url', 'Content type', 'Grouping', 'Comments']]
    page.should have_exact_table 'table tbody', [
      ['/contact_us', 'Publishing / Detail', 'Bee health', 'Hello'],
      ['/',           'Topic',               '',           '']]
  end

  scenario 'View a url for scraping that currently has not been scraped' do
    visit site_urls_path(site1, scrapable: true)
    click_link '/contact_us'

    page.should have_list_in_this_order '.urls', ['/contact_us - Publishing / Detail - Bee health', '/ - Topic', ]
    page.should have_content 'Hello'
    page.should have_an_iframe_for(url3.url)
  end
end
