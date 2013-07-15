FactoryGirl.define do
  factory :url_group_type do
    sequence(:name) { |n| "Series #{n}" }
  end
end