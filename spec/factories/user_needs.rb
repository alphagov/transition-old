FactoryGirl.define do
  factory :user_need do
    sequence(:name) { |n| "User need #{n}" }
  end
end