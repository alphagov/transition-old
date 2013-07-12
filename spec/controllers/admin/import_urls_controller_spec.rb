require 'spec_helper'

describe Admin::ImportUrlsController do
  before(:all) { DatabaseCleaner.clean }

  let!(:organisation) { create :organisation }
  let!(:site) { create :site, organisation: organisation }

  before :each do
    login_as_stub_user
  end

  describe :import do
    describe :get do
      it "should assign organisations" do
        get :import
        assigns(:organisations).should == [site.organisation]
        response.should be_success
      end
    end

    describe :post do
      it "should display errors when no site id is provided" do
        post :import
        flash.now[:error].should include('Site needs to be selected')
      end

      it "should display errors when no file is provided" do
        post :import, site_id: site.id
        flash.now[:error].should == 'CSV file needs to be selected'
      end

      it "should import urls" do
        post :import, site_id: site.id, file: fixture_file_upload('/cic_abridged.csv')
        flash.now[:error].should be_nil
        Url.count.should == 5
      end
    end
  end
end