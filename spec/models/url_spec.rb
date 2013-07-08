require 'spec_helper'

describe Url do
  context :relationships do
    it { should belong_to(:site) }
  end

  context :validations do
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

  context :mapping do
    before :each do
      @site = create :site
      @host1 = create :host, host: 'www.attorney-general.gov.uk', site: @site
      @host2 = create :host, host: 'www.ago.gov.uk', site: @site
      @host3 = create :host, host: 'www.dfid.gov.uk'
      @mapping1 = create :mapping, path: '/this-is-a-url?hello', site: @site
    end

    it 'should find a mapping with the url http://www.attorney-general.gov.uk/this-is-a-url?hello' do
      url = create :url, url: 'http://www.attorney-general.gov.uk/this-is-a-url?hello', site: @site
      url.mapping.should == @mapping1
    end

    it 'should find a mapping with the url www.ago.gov.uk/this-is-a-url?hello' do
      url = create :url, url: 'http://www.ago.gov.uk/this-is-a-url?hello', site: @site
      url.mapping.should == @mapping1
    end

    it 'should not find a mapping with the url www.dfid.gov.uk/this-is-a-url?hello' do
      url = create :url, url: 'http://www.dfid.gov.uk/this-is-a-url?hello', site: @site
      url.mapping.should be_nil
    end
  end
end