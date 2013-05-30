FactoryGirl.define do
  factory :mapping do
    site { Site.first || FactoryGirl.create(:site) }
    http_status { 410 }
    path { '/' }
  end
end
