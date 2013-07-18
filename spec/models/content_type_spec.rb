require 'spec_helper'

describe ContentType do

  describe 'Relationships' do
    it { should have_many(:urls).dependent(:restrict) }
    it { should have_and_belong_to_many(:scrapable_fields) }
  end

  describe 'Validations' do
    it { should validate_uniqueness_of(:subtype).scoped_to(:type).case_insensitive }
    it { should validate_presence_of(:type) }
    it { should_not validate_presence_of(:subtype) }

    it 'differentiates on subtype' do
      create :content_type
      lambda { create :content_type_with_no_subtype }.should_not raise_error
    end
  end

  describe '#to_s' do
    context 'both parts are supplied' do
      subject(:content_type) { build(:content_type) }

      its(:to_s) { should eql('Publication / Policy paper') }
    end

    context 'only the main type is supplied' do
      subject { build(:content_type_with_no_subtype) }

      its(:to_s) { should eql('Publication') }
    end
  end

  describe :is_detailed_guide? do
    it 'should return true where content type is Detailed guide' do
      content = build :content_type, type: 'Detailed guide'
      content.is_detailed_guide?.should be_true
    end

    it 'should return true where content type is not Detailed guide' do
      content = build :content_type, type: 'News'
      content.is_detailed_guide?.should be_false
    end
  end
end
