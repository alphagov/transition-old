FactoryGirl.define do
  factory :content_type do
    type      'Publication'
    subtype   'Policy paper'

    scrapable true

    factory :content_type_with_no_subtype do
      subtype nil
    end
  end
end
