FactoryGirl.define do
  factory :scrapable_field do
    name 'title'
    type 'string'

    factory :that_belong_to_content_types do
      after(:build) do |f|
        f.content_types << build(:detailed_guide_content_type)
      end

      factory :scrapable_field_title do
      end

      factory :scrapable_field_body do
        name 'body'
        type 'text'
      end

      factory :scrapable_field_summary do
        name 'summary'
        type 'text'
      end
    end
  end
end