require 'spec_helper'

describe UrlsController do
  before :each do
    login_as_stub_user
    @organisation = create :organisation, abbr: 'DFID', title: 'DFID'
    @site = create :site, organisation: @organisation
  @url = create :url, site: @site
  end
  
  context :index do
    it "should populate organisation and urls" do
      get :index, organisation_id: @organisation
      assigns(:organisation).should == @organisation
      assigns(:urls).should == [@url]
    end
  end

  context :show do
    it "should populate organisation and url" do
      get :show, organisation_id: @organisation, id: @url
      assigns(:organisation).should == @organisation
      assigns(:url).should == @url
    end
  end
end