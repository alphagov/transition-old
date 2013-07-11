FactoryGirl.define do
  factory :no_seq_host, class: Host do
    host "www.ministry-of-funk.org"
    ttl 1
    cname "MyString"
    live_cname "MyString"
    association :site
  end

  factory :natural_england_host, class: Host do
    host 'www.naturalengland.org.uk'

    association :site, factory: :natural_england_site
  end
end
