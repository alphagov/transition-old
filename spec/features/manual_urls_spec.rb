require 'features/features_helper'

feature 'View manual urls for a site and create/update them' do
  background do
    login_as_stub_user
  end

  let(:organisation)  { site.organisation }
  let(:site)          { host.site }
  let!(:host)         { create :natural_england_host }
  let!(:content_type) { create :content_type, type: 'Publication', subtype: nil }
  let!(:guidance)     { create :url_group, name: 'Development anlysis' }
  let!(:series)       { create :url_group, name: 'Doc series 1' }
  let!(:user_need)    { create :user_need, name: 'To blow bubbles' }
  let!(:url1)         { create :url, site: site, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', 
                               for_scraping: false, state: 'finished' }
  let!(:url2)         { create :url, site: site, url: 'http://www.naturalengland.org.uk/help', for_scraping: nil, 
                        content_type: content_type, guidance: guidance, series: series, user_need: user_need, comments: 'Hello', state: 'finished' }
  let!(:url3)         { create :url, site: site, for_scraping: true, state: 'finished' }
  let!(:url4)         { create :url, site: site, for_scraping: false }
  let!(:mapping1)     { create :mapping, new_url: 'http://www.gov.uk/natural-england', path: '/about_us/default.aspx', site: site }

  scenario 'Visit the Manual page for a site and see all site urls that are final and not for scraping', js: true do
    visit organisation_path(organisation)
    click_link 'Manual'

    page.should have_exact_table 'table thead', [
      ['Url', 'Content type', 'Guidance', 'Document series', 'User needs', 'Comments', 'Mapping']]
    page.should have_exact_table 'table tbody', [
      ['/about_us/default.aspx', '', '', '', '', '', 'hidden_field: http://www.gov.uk/natural-england'],
      ['/help', 'Publication', 'Development anlysis', 'Doc series 1', 'To blow bubbles', 'Hello', 'hidden_field:']]

    # update the mapping
    within(:xpath, "(//table/tbody/tr)[1]") do
      click_button 'Edit'
      find('input[type=text]').value.should == 'http://www.gov.uk/natural-england'
      find('input[type=text]').set 'http://news.bbc.co.uk'
      click_link 'Cancel'

      click_button 'Edit'
      find('input[type=text]').value.should == 'http://www.gov.uk/natural-england'
      find('input[type=text]').set 'http://news.bbc.co.uk'
      click_button 'Save'

      page.should have_content 'http://news.bbc.co.uk'
      page.should have_button 'Edit'
      page.should_not have_button 'Save'
      page.should_not have_link 'Cancel'
    end
  end

  scenario 'Fail to create a mapping due to an invalid host', js: true do
    host.update_attribute(:host, 'www.naturalengland-modified.org.uk')
    visit organisation_path(organisation)
    
    click_link 'Manual'

    # fail to update the mapping
    within(:xpath, "(//table/tbody/tr)[1]") do  
      click_button 'Edit'
      find('input[type=text]').set 'http://news.bbc.co.uk'
      click_button 'Save'

      page.should have_content 'No site host found'
      page.should_not have_content 'http://news.bbc.co.uk'
      page.should have_button 'Save'
      page.should have_link 'Cancel'
      page.should_not have_button 'Edit'
    end
  end
end
