require 'spec_helper'

describe UrlGroupsController do
  let!(:organisation1) { create :organisation, abbr: 'DFID', title: 'DFID' }
  let!(:organisation2) { create :organisation }
  let!(:guidance_group_type) { create :guidance_group_type }
  let!(:url_group) { create :url_group, name: 'Aloha', organisation: organisation1, url_group_type: guidance_group_type }

  before :each do
    login_as_stub_user
  end

  describe :create do
    context "valid url group data is provided" do
      it "should save a new url group" do
        post :create, url_group: {name: 'Aloha', organisation_id: organisation2.id, url_group_type_id: guidance_group_type.id }
        UrlGroup.where(name: 'Aloha').size.should == 2
        attributes = UrlGroup.last.attributes
        %w(created_at updated_at).each {|key| attributes.delete(key) }
        JSON.parse(response.body)['model'].should == attributes
        JSON.parse(response.body)['errors'].should be_empty
      end
    end

    context "invalid url group data is provided" do
      it "should fail to save a new url group" do
        post :create, url_group: {name: 'Aloha', organisation_id: organisation1.id, url_group_type_id: guidance_group_type.id }
        UrlGroup.where(name: 'Aloha').size.should == 1
        JSON.parse(response.body)['errors'].should == ["Name has already been taken"]
      end
    end
  end
end
