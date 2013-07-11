# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organisation do
    sequence(:abbr) { |n| "MyString#{n}" }
    title "MyString"
    launch_date "2013-04-16"
    homepage "MyString"
    furl "MyString"
  end
end
