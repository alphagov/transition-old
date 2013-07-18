require 'spec_helper'

describe ScrapeResult do
  describe :relationships do
    it { should belong_to(:scrapable) }
  end

  describe :validations do
    it { should validate_presence_of(:scrapable) }
  end

  describe :field_value do
    it 'should return nil if data is empty' do
      ScrapeResult.new.field_value('not_known').should be_nil
    end

    it 'should return the value for a specific field stored as json in data' do
      scrape = ScrapeResult.new(data: {field_a: 'Hello'}.to_json)
      scrape.field_value('field_a').should == 'Hello'
    end
  end
end
