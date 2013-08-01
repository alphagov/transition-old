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

        it 'should not include the duplicated canonicalize!d URL' do
          Url.where(url: 'https://www.bis.gov.uk/CicRegulator').first.should be_nil
        end

        it 'should pass through the key=value on the last URL' do
          Url.where(url:
            'http://www.bis.gov.uk/cicregulator/forms-introduction/index/forming-community-interest-plc?key=value') \
            .first.should be_a(Url)
        end
      end
    end

  end
end
