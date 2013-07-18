require 'spec_helper'

describe ScrapeResultsController do
  let!(:organisation) { create :organisation, abbr: 'DFID', title: 'DFID' }
  let!(:site) { create :site, organisation: organisation }
  let!(:url1) { create :url, site: site, is_scrape: false }
  let!(:url2) { create :url, site: site, is_scrape: true }

  before :each do
    login_as_stub_user
  end

  describe :new do
    it "should give a 404 if the url is not scrapable" do
      get :new, site_id: site, url_id: url1
      response.status.should eql 404
    end

    it "should instantiate a new scrape result" do
      get :new, site_id: site, url_id: url2
      assigns(:scrape_result).should be_a(ScrapeResult)
    end
  end
end