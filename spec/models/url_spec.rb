require 'spec_helper'

describe Url do
  describe :relationships do
    it { should belong_to(:site) }
  end

  describe :validations do
    it 'should make url unique' do
      create :url
      should validate_uniqueness_of(:url).case_insensitive
    end
    it { should validate_presence_of(:site) }
  end
end
