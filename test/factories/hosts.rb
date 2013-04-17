# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :host do
    host "MyString"
    ttl 1
    cname "MyString"
    live_cname "MyString"
  end
end
