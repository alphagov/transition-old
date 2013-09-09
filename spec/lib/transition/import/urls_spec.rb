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

      describe '.from_hostpath_rows!' do
        let!(:site) { create :site }
        let!(:host) { create :host, site: site, host: 'host.co.uk' }

        # These resemble what our GA query will return, see +Transition::Google::ResultsPager+
        let(:hostpath_rows) {[
          ['host.co.uk', '/path', 30],
          ['host.co.uk', '/path2', 20],
          ['nohost.co.uk', '/path', 10],
        ]}

        before do
          Urls.from_hostpath_rows!(hostpath_rows).failed_instances.each { |hit| puts hit.errors.full_messages }
        end

        it 'should import 2 hits' do
          Hit.count.should == 2
        end

        describe 'The first hit' do
          subject(:hit) { Hit.first }

          it              { should_not be_nil }
          its(:path)      { should eql '/path' }
          its(:path_hash) { should eql Digest::SHA1.hexdigest(hit.path) }
          its(:host)      { should eql host }
          its(:count)     { should eql(0) }
          its(:hit_on)    { should eql(Hit::NEVER) }
        end
      end
    end

  end
end
