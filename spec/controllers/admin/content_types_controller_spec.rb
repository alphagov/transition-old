require 'spec_helper'

describe Admin::ContentTypesController do
  let!(:content_type1) { create :content_type, type: 'Type 1', subtype: 'Subtype 1' }

  before :each do
    login_as_stub_user
  end

  describe :new do
    it "should instantiate a new content type" do
      get :new
      assigns(:content_type).should be_a(ContentType)
    end
  end

  describe :create do
    context "valid data is provided" do
      it "should save a new content and redirect" do
        post :create, content_type: {type: 'hello'}
        ContentType.find_by_type('hello').should_not be_nil
        response.should redirect_to(admin_content_types_path)
      end
    end

    context "invalid data is provided" do
      it "should fail to save a new content type" do
        post :create, content_type: { }
        response.should render_template('new')
      end
    end
  end

  describe :edit do
    it "should instantiate an existing content type" do
      get :edit, id: content_type1
      assigns(:content_type).should == content_type1
    end
  end

  describe :update do
    context "valid data is provided" do
      it "should update an existing content type" do
        put :update, id: content_type1, content_type: {type: 'Type 1 mod'}
        ContentType.find_by_type('Type 1 mod').should_not be_nil
        response.should redirect_to(admin_content_types_path)
      end
    end

    context "invalid data is provided" do
      it "should fail to update an content type" do
        put :update, id: content_type1, content_type: {type: ''}
        ContentType.find_by_type('Type 1 mod').should be_nil
        response.should render_template('edit')
      end
    end
  end

  describe :destroy do
    it "should delete an existing content type" do
      delete :destroy, id: content_type1
      ContentType.find_by_id(content_type1).should be_nil
    end
  end

  describe :index do
    it "should list all site mappings" do
      get :index
      assigns(:content_types).should == [content_type1]
    end
  end
end