require 'spec_helper'

describe 'scrape_results/index.csv.erb' do
  let(:test_results)        { 3.times.map { create :scrape_result } }
  let(:first_scrape_result) { test_results[0] }

  before do
    create :detailed_guide_content_type
    Transition::Import::ScrapableFields.seed!
    assign(:scrape_results, test_results)

    render

    @csv = CSV.parse(rendered)
  end

  it 'has headers' do
    @csv.first.should == ScrapeResultsHelper::COLUMN_NAMES
  end

  describe 'the first row' do
    subject(:row) {
      CSV::Row.new(ScrapeResultsHelper::COLUMN_NAMES, @csv[1], true)
    }

    its(['id'])       { should eql(first_scrape_result.id.to_s)  }
    its(['title'])    { should eql(first_scrape_result.field_values['title']) }
    its(['summary'])  { should eql(first_scrape_result.field_values['summary']) }
    its(['body'])     { should eql(first_scrape_result.field_values['body']) }
  end
end