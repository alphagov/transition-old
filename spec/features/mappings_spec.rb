require 'features/features_helper'

feature 'Viewing mappings for a site' do
  before(:all) do
    DatabaseCleaner.clean
  end

  background do
    login_as_stub_user
  end

  describe :index_edit do
    let(:organisation)  { site.organisation }
    let(:site)          { host.site }
    let!(:host)         { create :natural_england_host }
    let!(:mapping1)     { create :mapping, new_url: 'http://www.gov.uk/natural-england', path: '/about_us/default.aspx', site: site, http_status: '410' }
    let!(:mapping2)     { create :mapping, new_url: 'http://www.gov.uk/natural-england/contact-us', path: '/contact_us', site: site, http_status: '301' }
  
    scenario 'Visiting the mappings page for a site' do
      visit organisation_path(organisation)
      click_link 'View naturalengland mappings'

      page.should have_exact_table 'table thead', [
        ['', 'HTTP Status', 'Original URL', 'New URL', 'Suggested URL', 'Archive URL', '']]
      page.should have_exact_table 'table tbody', [
        ['Edit', '410', '/about_us/default.aspx', 'http://www.gov.uk/natural-england', '', ''],
        ['Edit', '301', '/contact_us', 'http://www.gov.uk/natural-england/contact-us', '', '']]
    end

    scenario 'Edit a mapping page' do
      visit site_mappings_path(site)
      within 'table tbody tr:first-child' do
        click_link 'Edit'
      end

      page.current_path.should == edit_site_mapping_path(site, mapping1)
      page.should have_field('Path', with: '/about_us/default.aspx')
      page.should have_field('New url', with: 'http://www.gov.uk/natural-england')
      page.should have_select('Http status', selected: '410')

      fill_in 'New url', with: 'http://www.gov.uk/natural-scotland'
      select '301', from: 'Http status'

      click_button 'Save'

      page.current_path.should == site_mappings_path(site)
      page.should have_exact_table 'table tbody', [
        ['Edit', '301', '/about_us/default.aspx', 'http://www.gov.uk/natural-scotland', '', ''],
        ['Edit', '301', '/contact_us', 'http://www.gov.uk/natural-england/contact-us', '', '']]
    end
  end

  describe :create do
    let!(:host) { create :no_seq_host }
    let!(:site) { host.site }

    scenario 'Create a new mapping' do
      visit site_mappings_path(site)
      click_link 'New Mapping'

      fill_in('Path', with: '/some_path')
      fill_in('New url', with: 'http://news.bbc.co.uk')
      page.should have_field('Suggested url')
      page.should have_field('Archive url')
      page.should have_select('Http status', options: ['301', '410'])
      
      click_button 'Save'

      page.current_path.should == site_mappings_path(site)
      page.should have_content('Mapping saved')
      page.should have_exact_table 'table tbody', [
        ['Edit', '301', '/some_path', 'http://news.bbc.co.uk', '', '', '']]
    end
  end
end
