require 'spec_helper'
require 'transition/import/content_types'

module Transition
  module Import

    describe ContentTypes do
      describe ".from_csv!" do
        before :all do
          DatabaseCleaner.clean!
          FactoryGirl.create(:content_type)
          ContentTypes.from_csv!(fixture_file('content_types_abridged.csv'))
        end

        after :all do
          DatabaseCleaner.clean!
        end

        it 'should import some content_types' do
          ContentType.count.should == 5
        end

        describe 'The first entry' do
          subject(:content_type) { ContentType.first }

          its(:type)      { should eql('Publication') }
          its(:subtype)   { should eql('Policy paper') }
          its(:scrapable) { should be_true }
        end
      end
    end

  end
end
