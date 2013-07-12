require 'spec_helper'

describe ContentType do
  before :all do
    DatabaseCleaner.clean
  end

  describe 'Validations' do
    it { should validate_uniqueness_of(:subtype).scoped_to(:type).case_insensitive }
    it { should validate_presence_of(:type) }
    it { should_not validate_presence_of(:subtype) }

    it 'differentiates on subtype' do
      create :content_type
      create :content_type_with_no_subtype
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
end
