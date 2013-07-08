require 'spec_helper'

describe UrlsController do
  before :each do
    login_as_stub_user
    @organisation = create :organisation, abbr: 'DFID', title: 'DFID'
    @site = create :site, organisation: @organisation
    @url = create :url, site: @site
    @url2 = create :url, site: @site
    @host = create :host, site: @site, host: 'www.ministry-of-funk.org'
  end

  describe :index do
    it 'populates organisation and urls' do
      get :index, organisation_id: @organisation
      assigns(:organisation).should == @organisation
      assigns(:urls).should == [@url, @url2]
    end
  end

  describe :show do
    it 'populates organisation and url' do
      get :show, organisation_id: @organisation, id: @url
      assigns(:organisation).should == @organisation
      assigns(:url).should == @url
    end
  end

  describe '#update' do
    context 'Manual is clicked' do
      context 'without a mapping URL' do
        before { post :update, organisation_id: @organisation, id: @url, destiny: 'manual' }

        describe 'the URL' do
          subject(:url) { Url.find_by_id(@url.id) }
          it { should be_manual }
        end

        it 'redirects to the next url in the list' do
          response.should redirect_to(organisation_url_path(@organisation, @url2))
        end
      end

      context 'with a mapping URL' do
        let(:test_destination) { 'http://gov.uk/somewhere' }

        before do
          post :update, organisation_id: @organisation, id: @url, destiny: 'manual', new_url: test_destination
        end

        describe 'the URL' do
          subject { Url.find_by_id(@url.id) }

          it { should be_manual }
          its(:new_url) { should eql(test_destination) }
        end
      end
    end
  end
end