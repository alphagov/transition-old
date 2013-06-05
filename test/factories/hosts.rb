# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :host do
    sequence(:host) { |n| "www#{n}.ministry-of-funk.org" }
    ttl 1
    cname "MyString"
    live_cname "MyString"
  end

  factory :gds_managed_host, parent: :host do
    cname "www.ministry-of-funk#{Host::GDS_CNAME}"
  end
end
