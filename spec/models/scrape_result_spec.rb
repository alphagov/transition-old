require 'spec_helper'

describe ScrapeResult do
  describe 'Relationships' do
    it { should belong_to(:scrapable) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:scrapable) }

    describe 'mandatory scrapable fields' do
      before :each do
        field1 = create :scrapable_field, name: 'title', mandatory: true
        field2 = create :scrapable_field, name: 'summary', mandatory: false
        @content_type = create :content_type
        @content_type.scrapable_fields << field1 << field2
      end
      
      describe 'url as scrapable' do
        it 'should be invalid for a scrape result to have empty mandatory fields if the associated url is marked as scrape finished' do
          url = create :url, content_type: @content_type, scrape_finished: true
          scrape = build :scrape_result, scrapable: url, data: nil
          scrape.should_not be_valid
        end

        it 'should be valid if there are empty mandatory fields when scrape_finished is false' do
          url = create :url, content_type: @content_type, scrape_finished: false
          scrape = build :scrape_result, scrapable: url, data: nil
          scrape.should be_valid
        end

        it 'should be valid if there are no empty mandatory fields when scrape_finished is true' do
          url = create :url, content_type: @content_type, scrape_finished: true
          scrape = build :scrape_result, scrapable: url, data: '{"title":"California Dreaming","summary":""}'
          scrape.should be_valid
        end
      end

      describe 'url group as scrapable' do
        before :each do
          @url1 = create :url, content_type: @content_type, scrape_finished: true, for_scraping: true
          @url_group = create :url_group
          @url_group.urls << @url1
        end
        it 'should be invalid for a scrape result to have empty mandatory fields if the url group is scrape finished' do
          scrape = build :scrape_result, scrapable: @url_group, data: nil
          scrape.should_not be_valid
        end

        it 'should be valid if there are empty mandatory fields when scrape_finished is false' do
          url = create :url, content_type: @content_type, scrape_finished: false, for_scraping: true
          scrape = build :scrape_result, scrapable: url, data: nil
          scrape.should be_valid
        end

        it 'should be valid if there are no empty mandatory fields when scrape_finished is true' do
          url = create :url, content_type: @content_type, scrape_finished: true, for_scraping: true
          scrape = build :scrape_result, scrapable: url, data: '{"title":"California Dreaming","summary":""}'
          scrape.should be_valid
        end
      end
    end
  end

  describe '#field_values' do
    it 'should return nil if data is empty' do
      ScrapeResult.new.field_values['not_known'].should be_nil
    end

    it 'should return the value for a specific field stored as json in data' do
      scrape = ScrapeResult.new(data: {field_a: 'Hello'}.to_json)
      scrape.field_values['field_a'].should == 'Hello'
    end
  end

  describe '#urls and #organisation' do
    context '#scrapable is a Url' do
      let(:url) { create :url }

      subject(:scrape_result) { build :scrape_result, scrapable: url }

      its(:urls)         { should eql([url]) }
      its(:organisation) { should eql(url.site.organisation) }
    end

    context '#scrapable is a UrlGroup' do
      let(:grouped_url) { create :scraped_url_with_content_type_in_url_group }

      subject(:scrape_result) { build :scrape_result, scrapable: grouped_url.url_group }

      its(:urls) { should eql([grouped_url]) }
      its(:organisation) { should eql(grouped_url.url_group.organisation) }
    end

  end
end
