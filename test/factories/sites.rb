# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    sequence(:site) { |n| "MyString#{n}" }
    homepage "MyString"
    query_params "MyString"
    tna_timestamp "2013-04-16 20:08:37"
    association :organisation
  end
end
