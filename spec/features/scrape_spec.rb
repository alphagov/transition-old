require 'features/features_helper'

feature 'Scraping' do
  let(:organisation) { site1.organisation }
  let(:host) { create :natural_england_host }
  let(:site1) { host.site }
  let(:site2) { create :site, organisation: organisation }

  let!(:content_type) { create :content_type, type: 'Publishing', subtype: 'Detail'}
  let!(:url_group) { create :url_group, name: 'Bee health'}
  let!(:url1) { create :url, url: 'http://www.naturalengland.org.uk/', site: site1, is_scrape: true }
  let!(:url2) { create :url, site: site2, is_scrape: true }
  let!(:url3) { create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: site1, is_scrape: true, 
                content_type: content_type, url_group: url_group}
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
      ['http://www.naturalengland.org.uk/', '', '',    ''],
      ['http://www.naturalengland.org.uk/contact_us', 'Publishing / Detail', 'Bee health', '']]
  end
end
