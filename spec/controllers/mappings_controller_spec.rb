require 'spec_helper'

describe MappingsController do
  before(:all) { DatabaseCleaner.clean }

  let!(:organisation) { create :organisation, abbr: 'DFID', title: 'DFID' }
  let!(:site) { create :site, organisation: organisation }
  let!(:mapping1) { create :mapping, path: '/hello-b', site: site }
  let!(:mapping2) { create :mapping, path: '/hello-a', site: site }

  before :each do
    login_as_stub_user
  end

  describe :new do
    it "should instantiate a new mapping" do
      get :new, site_id: site
      assigns(:mapping).should be_a(Mapping)
    end
  end

  describe :create do
    context "valid mapping data is provided" do
      it "should save a new mapping and redirect" do
        post :create, site_id: site, mapping: {path: 'hello', http_status: '301'}
        site.mappings.find_by_path('hello').should_not be_nil
        response.should redirect_to(site_mappings_path(site))
      end
    end

    context "invalid mapping data is provided" do
      it "should fail to save a new mapping" do
        post :create, site_id: site, mapping: {path: 'hello'}
        site.mappings.find_by_path('hello').should be_nil
        response.should render_template('new')
      end
    end
  end

  describe :edit do
    it "should instantiate an existing mapping" do
      get :edit, site_id: site, id: mapping1
      assigns(:mapping).should == mapping1
    end
  end

  describe :update do
    context "valid mapping data is provided" do
      it "should update an existing mapping" do
        put :update, site_id: site, id: mapping1, mapping: {path: '/hello-b-mod'}
        site.mappings.find_by_path('/hello-b-mod').should_not be_nil
        response.should redirect_to(site_mappings_path(site))
      end
    end

    context "invalid mapping data is provided" do
      it "should fail to update an existing mapping" do
        put :update, site_id: site, id: mapping1, mapping: {path: '/hello-b-mod', http_status: ''}
        site.mappings.find_by_path('/hello-b-mod').should be_nil
        response.should render_template('edit')
      end
    end
  end

  describe :destroy do
    it "should delete an existing mapping" do
      delete :destroy, site_id: site, id: mapping1
      Mapping.find_by_id(mapping1).should be_nil
    end
  end

  describe :index do
    it "should list all site mappings" do
      get :index, site_id: site
      assigns(:site).should == site
      assigns(:mappings_data).mappings.should == [mapping2, mapping1]
    end
  end
end