FactoryGirl.define do
  factory :url do
    sequence(:url) { |n| "http://www.ministry-of-funk.org/someurl#{n}" }
    site { Site.first || FactoryGirl.build(:site) }
  end
end