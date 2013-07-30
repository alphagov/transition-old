require 'features/features_helper'

feature 'Filtering urls for a site' do
  let(:organisation) { site.organisation }
  let(:site1) { host.site }
  let(:site2) { create :site }
  let!(:host) { create :natural_england_host }
  let!(:content_type1) { create :content_type, type: 'Bling', subtype: nil }
  let!(:content_type2) { create :content_type, type: 'Publication', subtype: nil }

  let!(:url1) { create :url, url: 'http://www.naturalengland.org.uk/site', site: site1, content_type: content_type1 }
  let!(:url2) { create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: site1, content_type: content_type2 }
  let!(:url3) { create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: site1, content_type: content_type1 }
  let!(:url4) { create :url, url: 'http://www.dfid.org.uk/please_contact_us', site: site2 }

  background do
    login_as_stub_user
  end

  scenario 'Viewing all urls for a site and filtering them by content type', js: true do
    visit site_urls_path(site1)

    page.should have_list_in_this_order '.urls',
      ['/site', '/about_us/default.aspx', '/contact_us']
   
    page.should have_non_readonly_select('filter_by_content_type')
    select 'Bling', from: 'filter_by_content_type'

    page.should have_list_in_this_order '.urls',
      ['/site', '/contact_us']

    # check that filter is preserved on links and form submission
    page.should have_link(url3.url, href: site_url_path(site1, url3, content_type: content_type1.id))
    click_link url3.url
    page.should have_list_in_this_order '.urls',
      ['/site', '/contact_us']

    click_button 'Save for review later'
    page.should have_list_in_this_order '.urls',
      ['/site', '/contact_us']    
  end
end
