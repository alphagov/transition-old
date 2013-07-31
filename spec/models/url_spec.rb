require 'spec_helper'

describe Url do
  its(:state) { should eql(:new) }

  describe 'relationships' do
    it { should belong_to(:site) }
    it { should belong_to(:guidance) }
    it { should belong_to(:series) }
    it { should belong_to(:content_type) }
    it { should belong_to(:user_need) }
    it { should have_one(:scrape) }
  end

  describe 'validations' do
    it 'should make url unique' do
      create :url
      should validate_uniqueness_of(:url).case_insensitive
    end
    it { should validate_presence_of(:site) }

    context 'validate url group depending on content type' do
      context 'the url content type has mandatory_guidance set to true and there is a guidance' do
        it 'should be valid' do
          url = build :url, content_type: build(:content_type, mandatory_guidance: true), guidance: build(:url_group)
          url.should be_valid
        end
      end

      context 'the url content type has mandatory_guidance set to true but there is no guidance' do
        it 'should be invalid' do
          url = build :url, content_type: build(:content_type, mandatory_guidance: true), guidance: nil
          url.should_not be_valid
        end
      end
    end
  end

  describe 'scopes' do
    let!(:content_type1) { create :content_type, type: 'Publication' }
    let!(:content_type2) { create :content_type, type: 'Bling' }
    let!(:content_type3) { create :content_type, type: 'Publication' }
    let!(:url1) { create :url, for_scraping: true, content_type: content_type2, state: 'finished' }
    let!(:url2) { create :url, for_scraping: false, content_type: content_type1 }
    let!(:url3) { create :url, for_scraping: true, content_type: content_type3 }
    let!(:url4) { create :url, for_scraping: nil, content_type: content_type1 }

    it 'should return urls that have a completed state' do
      Url.final.should == [url1]
    end

    it 'should return urls that are not for scraping' do
      Url.manual.size.should == 2
      Url.manual.should include(url2, url4)
    end

    it 'should return the urls assigned to a specific content type' do
      Url.for_content_types([content_type3]).should == [url3]
    end

    it 'should return the urls assigned to a content type with the specified type' do
      Url.for_type('Publication').size.should == 3
      Url.for_type('Publication').should include(url2, url3, url4)
    end

    it 'should return urls marked to be scraped' do
      Url.for_scraping.size.should == 2
      Url.for_scraping.should include(url1, url3)
    end
  end

  describe 'next' do
    let!(:site1) { create :site }
    let!(:site2) { create :site }
    let!(:onsite_url1) { create :url, site: site1 }
    let!(:offsite_url) { create :url, site: site2 }
    let!(:onsite_url2) { create :url, site: site1 }

    it 'should return the next url in the list ordered by id' do
      onsite_url1.next(Url.scoped).should == offsite_url
      onsite_url1.next(site1.urls).should == onsite_url2
    end

    it 'should return the same url if the current url is the last one in the list ordered by id' do
      onsite_url2.next(site1.urls).should == onsite_url2
    end
  end

  describe '#scrape_result' do
    it 'should return the scrape result attached directly to the url' do
      url = create :url
      scrape = url.create_scrape!
      url.scrape_result.should == scrape
    end

    it 'should return the scrape result attached to the url group' do
      content_type = create :detailed_guide_content_type
      url_group = create(:url_group)
      scrape = url_group.create_scrape!
      url = create :url, content_type: content_type, guidance: url_group
      url.scrape_result.should == scrape
    end
  end

  describe 'Mappings' do
    before :each do
      @site = create :site
      @host1 = create :host, host: 'www.attorney-general.gov.uk', site: @site
      @host2 = create :host, host: 'www.ago.gov.uk', site: @site
      @host3 = create :host, host: 'www.dfid.gov.uk'
      @mapping1 = create :mapping, path: '/this-is-a-url?hello', new_url: 'http://news.bbc.co.uk', site: @site
    end

    describe '#new_url' do
      it 'should return nil' do
        build(:url).new_url.should be_nil
      end

      it 'should return nil' do
        url = create :url, url: 'http://www.attorney-general.gov.uk/this-is-a-url?hello', site: @site
        url.new_url.should == 'http://news.bbc.co.uk'
      end
    end

    describe '#mapping' do
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

    describe '#set_mapping_url' do
      it 'should update the existing mapping url' do
        url = create :url, url: 'http://www.attorney-general.gov.uk/this-is-a-url?hello', site: @site
        url.mapping.should == @mapping1
        url.set_mapping_url('http://news.bbc.co.uk')
        @mapping1.reload
        @mapping1.new_url.should == 'http://news.bbc.co.uk'
      end

      it 'should create a new mapping' do
        url = create :url, url: 'http://www.attorney-general.gov.uk/hello?is_the_truth', site: @site
        url.mapping.should be_nil
        url.set_mapping_url('http://news.bbc.co.uk')
        url.mapping.new_url.should == 'http://news.bbc.co.uk'
      end

      context 'site hosts do not match the URL host' do
        it 'should complain with a RuntimeError' do
          url = create :url, url: 'http://www.dfid.gov.uk/hello?is_the_truth', site: @site
          url.mapping.should be_nil
          mapping = url.set_mapping_url('http://news.bbc.co.uk')
          mapping.errors.full_messages.should == ['No site host found']
        end
      end
    end
  end
end
