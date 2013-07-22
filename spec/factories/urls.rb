FactoryGirl.define do
  factory :url do
    sequence(:url) { |n| "http://www.ministry-of-funk.org/someurl#{n}" }
    site { Site.first || FactoryGirl.build(:site) }

    factory :url_with_content_type do
      content_type { ContentType.where(type: 'Detailed guide', subtype: nil).first_or_initialize }

      factory :scraped_url_with_content_type_in_url_group do
        association :url_group

        scrape_finished true
      end
    end
  end
end