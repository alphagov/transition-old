require 'spec_helper'

describe Url do
  describe :relationships do
    it { should belong_to(:site) }
    it { should belong_to(:url_group) }
    it { should belong_to(:content_type) }
    it { should have_one(:scrape) }
  end

  describe :validations do
    it 'should make url unique' do
      create :url
      should validate_uniqueness_of(:url).case_insensitive
    end
    it { should validate_presence_of(:site) }

    context 'validate url group depending on content type' do
      it 'should be valid if the url content type has mandatory_url_group set to true and there is a url group' do
        url = build :url, content_type: build(:content_type, mandatory_url_group: true), url_group: build(:url_group)
        url.should be_valid
      end

      it 'should be invalid if the url content type has mandatory_url_group set to true and there is no url group' do
        url = build :url, content_type: build(:content_type, mandatory_url_group: true), url_group: nil
        url.should_not be_valid
      end
    end
  end

  describe '.for_scraping' do
    it 'should return urls marked to be scraped' do
      url1 = create :url, for_scraping: true
      url2 = create :url, for_scraping: false
      url3 = create :url, for_scraping: true
      Url.for_scraping.size.should == 2
      Url.for_scraping.should include(url1, url3)
    end
  end

  describe :scrape_result do
    it 'should return the scrape result attached directly to the url' do
      url = create :url
      scrape = url.create_scrape!
      url.scrape_result.should == scrape
    end

    it 'should return the scrape result attached to the url group' do
      content_type = create :detailed_guide_content_type
      url_group = create(:url_group)
      scrape = url_group.create_scrape!
      url = create :url, content_type: content_type, url_group: url_group
      url.scrape_result.should == scrape
    end
  end

  describe 'URL state' do
    it 'should default to new' do
      Url.new.state.should == :new
    end

    subject(:url) { create(:url) }

    its(:state) { should eql(:new) }
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
