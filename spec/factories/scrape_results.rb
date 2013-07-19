FactoryGirl.define do
  factory :scrape_result do
    association :scrapable, factory: :url_with_content_type

    data <<-JSON
      {
        "title": "Keeping bees out of fire engines",
        "summary": "This summer, bees are sleeping in fire engines",
        "body": "BZZZZZZZZZZZZZZZZZZZZZZZZ WOO WOO WOO BZZZZZZZZZZZZZZZZZZZ"
      }
JSON
  end
end
