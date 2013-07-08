require 'spec_helper'

describe UrlsController do
  before :each do
    login_as_stub_user
    @organisation = create :organisation, abbr: 'DFID', title: 'DFID'
    @site = create :site, organisation: @organisation
    @url = create :url, site: @site
    @url2 = create :url, site: @site
  end

  describe :index do
    it "should populate organisation and urls" do
      get :index, organisation_id: @organisation
      assigns(:organisation).should == @organisation
      assigns(:urls).should == [@url, @url2]
    end
  end

  describe :show do
    it "should populate organisation and url" do
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
    end
  end
end