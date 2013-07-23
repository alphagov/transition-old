require 'spec_helper'

describe ScrapableField do
  describe 'Relationships' do
    it { should have_and_belong_to_many(:content_types) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:type) }
  end

  describe 'scopes' do
    it 'should return scrapable fields marked as mandatory' do
      field1 = create :scrapable_field, name: 'field1', mandatory: false
      field2 = create :scrapable_field, name: 'field2', mandatory: true
      ScrapableField.mandatory.should == [field2]
    end
  end
end
