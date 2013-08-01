require 'spec_helper'

describe ManualUrlsController do
  let!(:site) { create :site }
  let!(:host) { create :host, host: 'www.attorney-general.gov.uk', site: site }
  let!(:mapping1) { create :mapping, path: '/hello-b', site: site }
  let!(:url1) { create :url, site: site, for_scraping: false, state: 'finished', url: 'http://www.attorney-general.gov.uk/help' }
  let!(:url2) { create :url, site: site, for_scraping: true, state: 'finished' }
  let!(:url3) { create :url, site: site, for_scraping: nil, state: 'finished', url: 'http://www.attorney-general.gov.uk/hello-b' }
  let!(:url4) { create :url, site: site, for_scraping: nil }

  before :each do
    login_as_stub_user
  end

  describe :index do
    it "should list urls not to be scrapped that are marked as final" do
      get :index, site_id: site
      assigns(:urls).should == [url1, url3]
    end
  end

  describe :update do
    context "mapping is successfully created/updated" do
      it "should save a new mapping" do
        put :update, site_id: site, id: url1.id, "mapping_url_#{url1.id}" => 'New mapping Url'
        JSON.parse(response.body)['errors'].should be_empty
        url1.mapping.new_url.should == 'New mapping Url'
      end

      it "should update an existing mapping" do
        put :update, site_id: site, id: url3.id, "mapping_url_#{url3.id}" => 'Updated mapping Url'
        JSON.parse(response.body)['errors'].should be_empty
        mapping1.reload.new_url.should == 'Updated mapping Url'
      end
    end

    context "invalid mapping data is provided" do
      it "should fail to save a new mapping" do
        host.update_attribute(:host, 'www.dfid.gov.uk')
        put :update, site_id: site, id: url1.id, "mapping_url_#{url1.id}" => 'New mapping Url'
        JSON.parse(response.body)['errors'].should == ['No site host found']
        url1.mapping.should be_nil
      end
    end
  end
end
