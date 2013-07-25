FactoryGirl.define do
  factory :user_need do
    sequence(:name) { |n| "User need #{n}" }
    association :organisation
  end
end