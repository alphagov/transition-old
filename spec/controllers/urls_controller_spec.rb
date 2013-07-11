require 'spec_helper'

describe UrlsController do
  before :each do
    login_as_stub_user
    @organisation = create :organisation, abbr: 'DFID', title: 'DFID'
    @site1 = create :site, organisation: @organisation
    @site2 = create :site, organisation: @organisation, site: 'site-2'
    @url1 = create :url, site: @site1
    @url2 = create :url, site: @site1
    @url3 = create :url, site: @site2
    @host = create :host, site: @site1, host: 'www.ministry-of-funk.org'
  end

  describe :index do
    it "should populate site, organisation and urls" do
      get :index, site_id: @site1
      assigns(:site).should == @site1
    end
  end

  describe :show do
    it "should populate site and url" do
      get :show, site_id: @site1, id: @url1
      assigns(:site).should == @site1
      assigns(:url).should == @url1
    end
  end

  describe '#update' do
    context 'Manual is clicked' do
      context 'without a mapping URL' do
        before { post :update, site_id: @site1, id: @url1, destiny: 'manual' }

        describe 'the URL' do
          subject(:url) { Url.find_by_id(@url1.id) }
          its(:workflow_state) { should eql(:manual) }
        end

        it 'redirects to the next url in the list' do
          response.should redirect_to(site_url_path(@site1, @url2))
        end
      end

      context 'with a mapping URL' do
        let(:test_destination) { 'http://gov.uk/somewhere' }

        before do
          post :update, site_id: @site1, id: @url1, destiny: 'manual', new_url: test_destination
        end

        describe 'the URL' do
          subject { Url.find_by_id(@url1.id) }

          its(:workflow_state) { should eql(:manual) }
          its(:new_url) { should eql(test_destination) }
        end
      end
    end
  end
end
