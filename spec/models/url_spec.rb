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
        it 'should be manual' do
          url.manual!
          url.should be_manual
        end

        it 'creates no mapping' do
          url.should_not_receive(:set_mapping_url)
          url.manual!
        end
      end

      context 'when we have a to_url' do
        let(:to_url) { 'http://goes.here/' }

        it 'should be manual' do
          url.should_receive(:set_mapping_url).with(to_url)
          url.manual!(to_url)
          url.should be_manual
        end
      end
    end
  end
  
  describe :mappings do
    before :each do
      @site = create :site
      @host1 = create :host, host: 'www.attorney-general.gov.uk', site: @site
      @host2 = create :host, host: 'www.ago.gov.uk', site: @site
      @host3 = create :host, host: 'www.dfid.gov.uk'
      @mapping1 = create :mapping, path: '/this-is-a-url?hello', new_url: 'http://news.bbc.co.uk', site: @site
    end

    describe :new_url do
      it 'should return nil' do
        build(:url).new_url.should be_nil
      end

      it 'should return nil' do
        url = create :url, url: 'http://www.attorney-general.gov.uk/this-is-a-url?hello', site: @site
        url.new_url.should == 'http://news.bbc.co.uk'
      end
    end

    context :mapping do
      it 'should find a mapping with the url http://www.attorney-general.gov.uk/this-is-a-url?hello' do
        url = create :url, url: 'http://www.attorney-general.gov.uk/this-is-a-url?hello', site: @site
        url.mapping.should == @mapping1
      end

      it 'should find a mapping with the url www.ago.gov.uk/this-is-a-url?hello' do
        url = create :url, url: 'http://www.ago.gov.uk/this-is-a-url?hello', site: @site
        url.mapping.should == @mapping1
      end

      it 'should not find a mapping when the url and the sites hosts are inconsistent' do
        url = create :url, url: 'http://www.dfid.gov.uk/this-is-a-url?hello', site: @site
        url.mapping.should be_nil
      end
    end

    context :set_mapping_url do
      it "should update the existing mapping url" do
        url = create :url, url: 'http://www.attorney-general.gov.uk/this-is-a-url?hello', site: @site
        url.mapping.should == @mapping1
        url.set_mapping_url('http://news.bbc.co.uk')
        @mapping1.reload
        @mapping1.new_url.should == 'http://news.bbc.co.uk'
      end

      it "should create a new mapping" do
        url = create :url, url: 'http://www.attorney-general.gov.uk/hello?is_the_truth', site: @site
        url.mapping.should be_nil
        url.set_mapping_url('http://news.bbc.co.uk')
        url.mapping.new_url.should == 'http://news.bbc.co.uk'
      end

      it "should throw an exception if we try to create a mapping for a url where the site hosts do not match the url host" do
        url = create :url, url: 'http://www.dfid.gov.uk/hello?is_the_truth', site: @site
        url.mapping.should be_nil
        lambda {
          url.set_mapping_url('http://news.bbc.co.uk')
        }.should raise_error(RuntimeError, 'No site host found for http://www.dfid.gov.uk/hello?is_the_truth')
      end
    end
  end
end
