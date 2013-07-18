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
end
