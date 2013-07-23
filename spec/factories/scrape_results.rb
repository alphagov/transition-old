FactoryGirl.define do
  factory :scrape_result do
    association :scrapable, factory: :url
  end
end
