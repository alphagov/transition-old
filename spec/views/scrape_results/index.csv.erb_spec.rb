require 'spec_helper'

describe 'scrape_results/index.csv.erb' do
  let(:url_in_url_group)  { create(:scraped_url_with_content_type_in_url_group) }
  let(:urlgroup_result)   { create(:scrape_result, scrapable: url_in_url_group.guidance) }

  let(:test_results)        { 3.times.map { create :scrape_result } << urlgroup_result }
  let(:first_scrape_result) { test_results[0] }

  before do
    [:scrapable_field_title, :scrapable_field_summary, :scrapable_field_body].each { |field_type| create(field_type) }

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

    its(['id'])           { should eql(first_scrape_result.id.to_s)  }
    its(['title'])        { should eql(first_scrape_result.field_values['title']) }
    its(['summary'])      { should eql(first_scrape_result.field_values['summary']) }
    its(['organisation']) { should eql(first_scrape_result.organisation.abbr) }
    its(['old_url'])      { should eql(%(["#{test_results.first.scrapable.url}"])) }

    describe 'the body conversion to markdown' do
      subject(:markdown) { row['body'] }

      it { should include('# Bees') }
      it { should include("* WOO\n* WOO\n* WOO") }

      describe 'the link' do
        it { should include('[BZZZZZZZZZZZZZZZZZZZ][1]') }
        it { should include('[1]: http://apiary.org') }
      end
    end
  end
end
