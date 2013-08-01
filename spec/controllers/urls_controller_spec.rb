require 'spec_helper'

describe UrlsController, expensive_setup: true do
  before :all do
    @organisation = create :organisation, abbr: 'DFID', title: 'DFID'
    @site1 = create :site, organisation: @organisation
    @site2 = create :site, organisation: @organisation, site: 'site-2'
    @content_type1 = create :content_type
    @content_type2 = create :content_type
    @url1 = create :url, site: @site1, content_type: @content_type1
    @url2 = create :url, site: @site1, content_type: @content_type2
    @url3 = create :url, site: @site2
    @host = create :host, site: @site1, host: 'www.ministry-of-funk.org'
  end

  before :each do
    login_as_stub_user
  end

  describe :index do
    it 'should populate site, urls and url' do
      get :index, site_id: @site1
      assigns(:url).should == @url1
      assigns(:urls).should == [@url1, @url2]
      assigns(:site).should == @site1
    end

    it 'should render the index template' do
      get :index, site_id: @site1
      response.should render_template('show')
    end

    it 'should filter the urls when a content type filter is specified' do
      get :index, site_id: @site1, content_type: @content_type2.id
      assigns(:url).should == @url2
      assigns(:urls).should == [@url2]
    end

    it 'should set flash message if no urls are found' do
      site = create :site
      get :index, site_id: site
      assigns(:url).should be_nil
      assigns(:urls).should == []
      assigns(:site).should == site
      flash.now[:error].should == 'No Urls were found'
    end
  end

  describe :show do
    describe 'assigns' do
      before do
        get :show, site_id: @site1, id: @url1
      end
      subject { assigns }

      its([:site])          { should == @site1 }
      its([:urls])          { should == [@url1, @url2] }
      its([:url])           { should == @url1 }
    end

    it 'should filter the urls when a content type filter is specified' do
      get :show, site_id: @site1, id: @url1, content_type: @content_type1.id
      assigns(:urls).should == [@url1]
      response.should be_success
    end

    it 'should redirect to the first url in a filtered list of urls if the selected url is not in that list' do
      get :show, site_id: @site1, id: @url1, content_type: @content_type2.id
      assigns(:url).should == @url2
      response.should redirect_to site_url_path(@site1, @url2, content_type: @content_type2.id)
    end

    it 'should set flash message if no urls are found' do
      get :show, site_id: @site2, id: @url3, content_type: @content_type2.id
      assigns(:url).should be_nil
      flash.now[:error].should == 'No Urls were found'
      response.should be_success
    end
  end

  describe '#update' do
    context 'Comments are provided' do
      it 'should update the url' do
        post :update, site_id: @site1, id: @url1, url: {comments: 'Hello'}
        @url1.reload
        @url1.comments.should == 'Hello'
      end

      it 'should redirect and preserve the content type filter' do
        post :update, site_id: @site1, id: @url1, url: {comments: 'Hello'}, content_type: @content_type1.id
        response.should redirect_to site_url_path(@url1.site, @url1, content_type: @content_type1.id)
      end
    end

    context 'invalid url' do
      it 'should fail to update the url' do
        content_type = create :content_type, type: 'Detailed Guide', subtype: nil, mandatory_guidance: true
        post :update, site_id: @site1, id: @url1, url: { content_type_id: content_type.id, comments: 'Hello' }
        response.should be_success
        @url1.reload
        @url1.comments.should_not == 'Hello'
      end

      it 'should populate urls according to the content type filter' do
        content_type = create :content_type, type: 'Detailed Guide', subtype: nil, mandatory_guidance: true
        post :update, site_id: @site1, id: @url1, url: { content_type_id: content_type.id, comments: 'Hello' },
             content_type: @content_type1.id
        assigns(:urls).should == [@url1]
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
    end
  end
end
