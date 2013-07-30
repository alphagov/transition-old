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

  describe 'guidance' do
    it 'should return a guidance url group type' do
      guidance = create :guidance_group_type
      UrlGroupType.guidance.should == guidance
    end

    it 'should return a series url group type' do
      series = create :series_group_type
      UrlGroupType.series.should == series
    end
  end
end
