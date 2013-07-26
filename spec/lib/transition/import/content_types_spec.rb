require 'spec_helper'
require 'transition/import/content_types'

module Transition
  module Import

    describe ContentTypes, expensive_setup: true do
      describe ".from_csv!" do
        before :all do
          create(:content_type, subtype: 'Policy paper')
          ContentTypes.from_csv!(fixture_file('content_types_abridged.csv'))
        end

        it 'should import some content_types' do
          ContentType.count.should == 5
        end

        describe 'The first entry' do
          subject(:content_type) { ContentType.first }

          its(:type)                { should eql('Publication') }
          its(:subtype)             { should eql(subject.subtype) }
          its(:scrapable)           { should be_true }
          its(:user_need_required)  { should be_false }
          its(:mandatory_guidance)  { should be_true }
        end
      end
    end

  end
end
