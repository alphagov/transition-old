FactoryGirl.define do
  factory :total do
    host { Host.first || FactoryGirl.create(:host) }
    sequence(:total_on) { |n| n.days.ago }
    count { 10 }
    http_status { 301 }
  end
end
