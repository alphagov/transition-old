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

  describe 'URL workflow' do
    subject(:url) { FactoryGirl.create(:url) }

    it { should be_new }

    describe 'archiving URLs' do
      before { url.archive! }

      it { should be_archived }
    end

    describe 'Indicating URLs will have manual content for them' do
      context "when we don''t have a to_url" do
        before { url.manual! }

        it { should be_manual }

        it 'creates no mapping' do
          pending 'not creating mappings yet'
        end
      end

      context 'when we have a to_url' do
        let(:to_url) { 'http://goes.here/' }

        before { url.manual!(to_url) }

        it { should be_manual }

        it 'creates a mapping' do
          pending 'not creating mappings yet'
        end
      end
    end
  end
end