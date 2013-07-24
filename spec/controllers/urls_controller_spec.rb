require 'spec_helper'

describe UrlsController, expensive_setup: true do
  before :all do
    @organisation = create :organisation, abbr: 'DFID', title: 'DFID'
    @site1 = create :site, organisation: @organisation
    @site2 = create :site, organisation: @organisation, site: 'site-2'
    @url1 = create :url, site: @site1
    @url2 = create :url, site: @site1
    @url3 = create :url, site: @site2
    @host = create :host, site: @site1, host: 'www.ministry-of-funk.org'
    @content_types = [create(:content_type)]
  end

  before :each do
    login_as_stub_user
  end

  describe :index do
    it 'should populate site' do
      get :index, site_id: @site1
      assigns(:site).should == @site1
    end

    it "should render the index template" do
      get :index, site_id: @site1
      response.should render_template('index')
    end
  end

  describe :show do
    before do
      get :show, site_id: @site1, id: @url1
    end

    describe 'assigns' do
      subject { assigns }

      its([:site])          { should == @site1 }
      its([:url])           { should == @url1 }
    end
  end

  describe '#update' do
    context 'Comments are provided' do
      it 'should update the url' do
        post :update, site_id: @site1, id: @url1, url: {comments: 'Hello'}
        @url1.reload
        @url1.comments.should == 'Hello'
      end
    end

    context 'invalid url' do
      it 'should fail to update the url' do
        content_type = create :content_type, type: 'Detailed Guide', subtype: nil, mandatory_url_group: true
        post :update, site_id: @site1, id: @url1, url: { content_type_id: content_type.id, comments: 'Hello' }
        response.should be_success
        @url1.reload
        @url1.comments.should_not == 'Hello'
      end
    end

    context 'Save for review later is clicked' do
      context 'without a mapping URL' do
        before { post :update, site_id: @site1, id: @url1, destiny: 'unfinished' }

        describe 'the URL' do
          subject(:url) { Url.find_by_id(@url1.id) }
          its(:state) { should eql(:unfinished) }
        end

        it 'redirects to the next url in the list' do
          response.should redirect_to(site_url_path(@site1, @url2))
        end
      end

      context 'with a mapping URL' do
        let(:test_destination) { 'http://gov.uk/somewhere' }

        before do
          post :update, site_id: @site1, id: @url1, destiny: 'unfinished', new_url: test_destination
        end

        describe 'the URL' do
          subject { Url.find_by_id(@url1.id) }

          its(:state) { should eql(:unfinished) }
          its(:new_url) { should eql(test_destination) }
          its(:http_status) { should == '301' }
        end
      end
    end
  end
end
