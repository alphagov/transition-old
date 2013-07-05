require 'spec_helper'

describe UrlsController do
  before :each do
    login_as_stub_user
  end
  
  context :index do
    before :each do
      @organisation = create :organisation, abbr: 'DFID', title: 'DFID'
      @site = create :site, organisation: @organisation
      @url = create :url, site: @site
    end

    it "should populate organisation and urls" do
      get :index, organisation_id: @organisation
      assigns(:organisation).should == @organisation
      assigns(:urls).should == [@url]
    end
  end
end