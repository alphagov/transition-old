FactoryGirl.define do
  factory :url_group do
    sequence(:name) { |n| "Series #{n}" }
    association :url_group_type
    association :organisation
  end
end