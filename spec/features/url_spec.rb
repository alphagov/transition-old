require 'features/features_helper'

feature "View url for an organisation" do
  before do
    login_as_stub_user
    @organisation = create :organisation, title: 'DFID'
    @site = create :site, organisation: @organisation
    create :url, url: 'http://www.naturalengland.org.uk/', site: @site
    @url1 = create :url, url: 'http://www.naturalengland.org.uk/about_us/default.aspx', site: @site
    create :url, url: 'http://www.naturalengland.org.uk/contact_us', site: @site
  end

  scenario "Url page with adjacent urls and iframe" do
    visit organisation_url_path(@organisation, @url1)

    page.should have_link('DFID', href: organisation_path(@organisation))
    should_have_table 'table thead', [
      ['*', 'Url']]
    should_have_table 'table tbody', [
      ['1', 'http://www.naturalengland.org.uk/'],
      ['2', 'http://www.naturalengland.org.uk/about_us/default.aspx'],
      ['3', 'http://www.naturalengland.org.uk/contact_us']]
    page.should have_xpath("//iframe[@src='#{@url1.url}']")
  end
end