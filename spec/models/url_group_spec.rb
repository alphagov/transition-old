require 'spec_helper'

describe UrlGroup do
  describe :relationships do
    it { should belong_to(:url_group_type) }
    it { should belong_to(:organisation) }
    it { should have_many(:urls).dependent(:restrict) }
    it { should have_one(:scrape) }
  end

  describe :validations do
    it 'should make url group name unique' do
      create :url_group
      should validate_uniqueness_of(:name).scoped_to(:organisation_id).case_insensitive
    end
    
    it { should validate_presence_of(:url_group_type) }
    it { should validate_presence_of(:organisation) }
  end

  describe :scopes do
    it 'should return all url groups for a given organisation' do
      org1 = create :organisation
      org2 = create :organisation
      url_group1 = create :url_group, name: 'Catchment sensitive farming', organisation: org1
      url_group2 = create :url_group, organisation: org2
      url_group3 = create :url_group, name: 'Bee health', organisation: org1

      UrlGroup.for_organisation(org1).should == [url_group3, url_group1]
    end
  end

  describe 'content_type' do
    it 'should return the content type of the first for_scraping url' do
      content_type = create :content_type
      url_group = create :url_group
      url_group.urls << build(:url, content_type: content_type, for_scraping: true)
      url_group.content_type.should == content_type
    end
  end

  describe 'scrape_finished' do
    before :each do
      @url_group = create :url_group
      2.times { @url_group.urls << create(:url, scrape_finished: true, for_scraping: true) }
      @url_group.urls << create(:url, scrape_finished: false, for_scraping: false)
    end
    it 'should be true if all scrapable urls are marked as scrape_finished' do
      @url_group.should be_scrape_finished
    end

    it 'should be false if there is one or more scrapable urls marked as not scrape_finished' do
      @url_group.urls << create(:url, scrape_finished: false, for_scraping: true)
      @url_group.should_not be_scrape_finished
    end
  end
end
