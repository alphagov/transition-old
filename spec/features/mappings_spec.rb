require 'features/features_helper'

feature 'Viewing mappings for a site' do
  let(:organisation)  { site.organisation }
  let(:site)          { host.site }
  let!(:host)         { create :natural_england_host }
  let!(:mapping1)     { create :mapping, new_url: 'http://www.gov.uk/natural-england', path: '/about_us/default.aspx', site: site, http_status: '410' }
  let!(:mapping2)     { create :mapping, new_url: 'http://www.gov.uk/natural-england/contact-us', path: '/contact_us', site: site, http_status: '301' }

  background do
    login_as_stub_user
  end

  scenario 'Visiting the url page when there are URLs' do
    visit organisation_path(organisation)
    click_link 'View naturalengland mappings'

    should_have_table 'table thead', [
      ['HTTP Status', 'Original URL', 'New URL', 'Suggested URL', 'Archive URL']]
    should_have_table 'table tbody', [
      ['410', '/about_us/default.aspx', 'http://www.gov.uk/natural-england', '', ''],
      ['301', '/contact_us', 'http://www.gov.uk/natural-england/contact-us', '', '']]
  end

  scenario 'Create a new mapping' do
    host2 = create :no_seq_host
    site2 = host2.site
    visit site_mappings_path(site2)
    click_link 'New Mapping'

    fill_in('Path', with: '/some_path')
    fill_in('New url', with: 'http://news.bbc.co.uk')
    page.should have_field('Suggested url')
    page.should have_field('Archive url')
    page.should have_select('Http status', options: ['301', '410'])
    
    click_button 'Save'

    page.current_path.should == site_mappings_path(site2)
    page.should have_content('Mapping saved')
    should_have_table 'table tbody', [
      ['301', '/some_path', 'http://news.bbc.co.uk', '', '']]
  end
end
