require 'spec_helper'

describe ScrapeResultsController do
  let(:content_type) do
    content_type = create :content_type, scrapable: true
    content_type.scrapable_fields << create(:scrapable_field, name: 'body', mandatory: true)
    content_type
  end

  let!(:organisation)     { create :organisation }
  let!(:site)             { create :site, organisation: organisation }
  let!(:other_site)       { create :natural_england_site, organisation: organisation }
  let!(:unscrapable_url)  { create :url, site: site, for_scraping: false }
  let!(:scrapable_url)    { create :url, site: site, for_scraping: true }
  let!(:offsite_url)      { create :url, site: other_site, for_scraping: true, scrape_finished: true }

  before :each do
    login_as_stub_user
  end

  describe :new do
    it "should give a 404 if the url is not scrapable" do
      get :new, site_id: site, url_id: unscrapable_url
      response.status.should eql 404
    end

    it "should assign url and instantiate a new scrape result" do
      get :new, site_id: site, url_id: scrapable_url
      assigns(:url).should == scrapable_url
      assigns(:scrape_result).should be_a(ScrapeResult)
    end

    it "should redirect to edit if scrape result already exists" do
      scrapable_url.create_scrape_result!
      get :new, site_id: site, url_id: scrapable_url
      response.should redirect_to(edit_site_scrape_result_path(site, scrapable_url.scrape_result, url_id: scrapable_url))
    end
  end

  describe '#index' do
    let!(:scraped_url)      { create :url, site: site, for_scraping: true, scrape_finished: true }
    let!(:onsite_result)    { create(:scrape_result, scrapable: scraped_url) }
    let!(:offsite_result)   { create(:scrape_result, scrapable: offsite_url) }
    let!(:url_in_url_group) { create(:scraped_url_with_content_type_in_url_group) }
    let!(:urlgroup_result)  { create(:scrape_result, scrapable: url_in_url_group.url_group) }

    before do
      get :index, site_id: site
    end

    subject(:results) { assigns[:scrape_results].to_a }

    it { should     include(onsite_result) }
    it { should_not include(offsite_result) }
    it { should     include(urlgroup_result) }
  end

  describe :create do
    it "should create a new scrape result" do
      post :create, site_id: site, url_id: scrapable_url, scrape_result: {field_a: 'Yeah'}
      scrapable_url.scrape_result.should_not be_nil
      scrapable_url.scrape_result.field_values['field_a'].should == 'Yeah'
    end

    it "should redirect to the edit page" do
      post :create, site_id: site, url_id: scrapable_url, scrape_result: {field_a: 'Yeah'}
      response.should redirect_to(edit_site_scrape_result_path(site, scrapable_url.scrape_result, url_id: scrapable_url))
    end

    it "should update the url as scrape_finished if 'Save as final'" do
      post :create, site_id: site, url_id: scrapable_url, scrape_result: {field_a: 'Yeah'}, button: 'finished'
      scrapable_url.reload.should be_scrape_finished
    end

    it "should fail to update the url as scrape_finished if 'Save as final' when mandatory fields are empty" do
      scrapable_url.update_attributes!(content_type_id: content_type.id)
      post :create, site_id: site, url_id: scrapable_url, scrape_result: {field_a: 'Yeah'}, button: 'finished'
      scrapable_url.reload.should_not be_scrape_finished
      assigns(:scrape_result).errors.full_messages.should == ['Body must be populated before scrape is marked as final']
    end
  end

  describe :edit do
    it "should assign the url and scrape result" do
      scrape = scrapable_url.create_scrape_result!
      get :edit, site_id: site, id: scrape, url_id: scrapable_url
      assigns(:url).should == scrapable_url
      assigns(:scrape_result).should == scrape
    end
  end

  describe 'update' do
    it "should update a scrape result and redirect to the edit page" do
      scrape = scrapable_url.create_scrape_result!
      put :update, site_id: site, id: scrape, url_id: scrapable_url, scrape_result: {field_a: 'Yeah'}
      scrape.reload.field_values['field_a'].should == 'Yeah'
      response.should redirect_to(edit_site_scrape_result_path(site, scrapable_url.scrape_result, url_id: scrapable_url))
    end
    
    it "should update the url as scrape_finished if 'Save as final'" do
      scrape = scrapable_url.create_scrape_result!
      put :update, site_id: site, id: scrape, url_id: scrapable_url, scrape_result: {field_a: 'Yeah'}, button: 'finished'
      scrapable_url.reload.should be_scrape_finished
    end

    it "should fail to update the url as scrape_finished if 'Save as final' when mandatory fields are empty" do
      scrapable_url.update_attributes!(content_type_id: content_type.id)
      scrape = scrapable_url.create_scrape_result!
      put :update, site_id: site, id: scrape, url_id: scrapable_url, scrape_result: {field_a: 'Yeah'}, button: 'finished'
      scrapable_url.reload.should_not be_scrape_finished
      assigns(:scrape_result).errors.full_messages.should == ['Body must be populated before scrape is marked as final']
    end
  end
end