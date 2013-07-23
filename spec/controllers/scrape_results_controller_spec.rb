require 'spec_helper'

describe ScrapeResultsController do
  let!(:organisation) { create :organisation, abbr: 'DFID', title: 'DFID' }
  let!(:site) { create :site, organisation: organisation }
  let!(:url1) { create :url, site: site, for_scraping: false }
  let!(:url2) { create :url, site: site, for_scraping: true }
  let(:content_type) do
    content_type = create :content_type, scrapable: true
    content_type.scrapable_fields << create(:scrapable_field, name: 'body', mandatory: true)
    content_type
  end

  before :each do
    login_as_stub_user
  end

  describe :new do
    it "should give a 404 if the url is not scrapable" do
      get :new, site_id: site, url_id: url1
      response.status.should eql 404
    end

    it "should assign url and instantiate a new scrape result" do
      get :new, site_id: site, url_id: url2
      assigns(:url).should == url2
      assigns(:scrape_result).should be_a(ScrapeResult)
    end

    it "should redirect to edit if scrape result already exists" do
      url2.create_scrape_result!
      get :new, site_id: site, url_id: url2
      response.should redirect_to(edit_site_scrape_result_path(site, url2.scrape_result, url_id: url2))
    end
  end

  describe :create do
    it "should create a new scrape result" do
      post :create, site_id: site, url_id: url2, scrape_result: {field_a: 'Yeah'}
      url2.scrape_result.should_not be_nil
      url2.scrape_result.field_value('field_a').should == 'Yeah'
    end

    it "should redirect to the edit page" do
      post :create, site_id: site, url_id: url2, scrape_result: {field_a: 'Yeah'}
      response.should redirect_to(edit_site_scrape_result_path(site, url2.scrape_result, url_id: url2))
    end

    it "should update the url as scrape_finished if 'Save as final'" do
      post :create, site_id: site, url_id: url2, scrape_result: {field_a: 'Yeah'}, button: 'finished'
      url2.reload.should be_scrape_finished
    end

    it "should fail to update the url as scrape_finished if 'Save as final' when mandatory fields are empty" do
      url2.update_attributes!(content_type_id: content_type.id)
      post :create, site_id: site, url_id: url2, scrape_result: {field_a: 'Yeah'}, button: 'finished'
      url2.reload.should_not be_scrape_finished
      assigns(:scrape_result).errors.full_messages.should == ['Body must be populated before scrape is marked as final']
    end
  end

  describe :edit do
    it "should assign the url and scrape result" do
      scrape = url2.create_scrape_result!
      get :edit, site_id: site, id: scrape, url_id: url2
      assigns(:url).should == url2
      assigns(:scrape_result).should == scrape
    end
  end

  describe :update do
    it "should update a scrape result and redirect to the edit page" do
      scrape = url2.create_scrape_result!
      put :update, site_id: site, id: scrape, url_id: url2, scrape_result: {field_a: 'Yeah'}
      scrape.reload.field_value('field_a').should == 'Yeah'
      response.should redirect_to(edit_site_scrape_result_path(site, url2.scrape_result, url_id: url2))
    end
    
    it "should update the url as scrape_finished if 'Save as final'" do
      scrape = url2.create_scrape_result!
      put :update, site_id: site, id: scrape, url_id: url2, scrape_result: {field_a: 'Yeah'}, button: 'finished'
      url2.reload.should be_scrape_finished
    end

    it "should fail to update the url as scrape_finished if 'Save as final' when mandatory fields are empty" do
      url2.update_attributes!(content_type_id: content_type.id)
      scrape = url2.create_scrape_result!
      put :update, site_id: site, id: scrape, url_id: url2, scrape_result: {field_a: 'Yeah'}, button: 'finished'
      url2.reload.should_not be_scrape_finished
      assigns(:scrape_result).errors.full_messages.should == ['Body must be populated before scrape is marked as final']
    end
  end
end