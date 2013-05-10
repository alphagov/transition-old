FactoryGirl.define do
  factory :hit do
    host { Host.first || FactoryGirl.create(:host) }
    sequence(:hit_on) { |n| n.days.ago }
    count { 10 }
    http_status { 301 }
    path { '/' }
  end
end
