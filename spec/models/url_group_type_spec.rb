require 'spec_helper'

describe UrlGroupType do
  describe :relationships do
    it { should have_many(:url_groups).dependent(:restrict) }
  end

  describe :validations do
    it 'should make url group name unique' do
      create :url_group_type
      should validate_uniqueness_of(:name).case_insensitive
    end
  end
end
