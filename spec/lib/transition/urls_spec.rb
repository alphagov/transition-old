require 'spec_helper'
require 'transition/import/urls'

module Transition
  module Import

    describe Urls, expensive_setup: true do
      describe ".from_csv!" do
        before :all do
          FactoryGirl.create(:cic_regulator)
          Urls.from_csv!('cic_regulator', fixture_file('cic_abridged.csv'))
        end

        it 'should import some urls' do
          Url.count.should == 5
        end

        describe 'The first entry' do
          subject(:entry) { Url.first }

          it { should_not be_nil }
          its(:url) { should eql('http://www.bis.gov.uk/cicregulator') }
        end
      end
    end

  end
end
