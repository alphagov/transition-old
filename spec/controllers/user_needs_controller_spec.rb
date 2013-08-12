require 'spec_helper'

describe UserNeedsController do
  let(:user_need) { create :user_need }
  let(:organisation) { create :organisation }

  before :each do
    login_as_stub_user
  end

  describe 'index' do
    it "should instantiate a new user need" do
      get :index
      assigns(:user_need).should be_a(UserNeed)
    end
  end

  describe 'create' do
    context "valid data is provided" do
      it "should save a new user need and redirect" do
        post :create, user_need: {name: 'User need 1', organisation_id: organisation.id}
        UserNeed.find_by_name('User need 1').should_not be_nil
        response.should redirect_to(user_needs_path(last_org_id: organisation.id))
      end
    end

    context "invalid data is provided" do
      it "should fail to save a new content type" do
        post :create, user_need: { }
        response.should render_template('index')
      end
    end
  end

  describe 'edit' do
    it "should instantiate an existing user need" do
      get :edit, id: user_need
      assigns(:user_need).should == user_need
    end
  end

  describe 'update' do
    context "valid data is provided" do
      it "should update an existing user_need" do
        put :update, id: user_need, user_need: {name: 'Name mod'}
        UserNeed.find_by_name('Name mod').should_not be_nil
        response.should redirect_to(user_needs_path)
      end
    end

    context "invalid data is provided" do
      it "should fail to update a user need" do
        put :update, id: user_need, user_need: {name: ''}
        response.should render_template('edit')
      end
    end
  end

  describe 'destroy' do
    it "should delete an existing user need" do
      delete :destroy, id: user_need
      UserNeed.find_by_id(user_need).should be_nil
    end

    it "should not delete an existing user need if there is an associated Url" do
      create :url, user_need_id: user_need.id
      delete :destroy, id: user_need
      UserNeed.find_by_id(user_need).should == user_need
      response.should render_template('edit')
    end
  end
end
