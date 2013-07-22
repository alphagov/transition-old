require 'spec_helper'
require 'transition/import/scrapable_fields'

module Transition
  module Import

    describe ScrapableFields, expensive_setup: true do
      describe ".seed!" do
        before :all do
          @detailed_guide = create(:content_type, type: 'Detailed guide', subtype: nil)
          ScrapableFields.seed!
        end

        specify { ScrapableField.all.should have(4).scrapable_fields }

        describe 'The first scrapable field' do
          subject(:field) { ScrapableField.first }

          its(:name)               { should eql('title') }
          its(:type)               { should eql('string') }
          its(:content_types)      { should include(@detailed_guide) }
        end
      end
    end

  end
end
