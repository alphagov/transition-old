require 'spec_helper'

describe UrlGroup do
  describe :relationships do
    it { should belong_to(:url_group_type) }
    it { should belong_to(:organisation) }
    it { should have_many(:urls).dependent(:restrict) }
  end

  describe :validations do
    it 'should make url group name unique' do
      create :url_group
      should validate_uniqueness_of(:name).scoped_to(:organisation_id).case_insensitive
    end
    
    it { should validate_presence_of(:url_group_type) }
    it { should validate_presence_of(:organisation) }
  end

  describe :scopes do
    it 'should return all url groups for a given organisation' do
      org1 = create :organisation
      org2 = create :organisation
      url_group1 = create :url_group, name: 'Catchment sensitive farming', organisation: org1
      url_group2 = create :url_group, organisation: org2
      url_group3 = create :url_group, name: 'Bee health', organisation: org1

      UrlGroup.for_organisation(org1).should == [url_group3, url_group1]
    end
  end
end
