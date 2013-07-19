FactoryGirl.define do
  factory :scrape_result do
    association :scrapable, factory: :url_with_content_type

    data <<-JSON
      {
        "title": "Keeping bees out of fire engines",
        "summary": "This summer, bees are sleeping in fire engines",
        "body": "<h1>Bees</h1><p>BZZZZZZZZZZZZZZZZZZZZZZZZ</p> <ul><li>WOO</li><li>WOO</li><li>WOO</li></ul> <a href='http://apiary.org'>BZZZZZZZZZZZZZZZZZZZ</a>"
      }
JSON
  end
end
