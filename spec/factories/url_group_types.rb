FactoryGirl.define do
  factory :url_group_type do
    sequence(:name) { |n| "Series #{n}" }
    factory :guidance_group_type do
      name UrlGroupType::GUIDANCE
    end
    factory :series_group_type do
      name UrlGroupType::SERIES
    end
  end
end
