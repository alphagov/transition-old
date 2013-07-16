FactoryGirl.define do
  factory :content_type do
    type 'Publication'
    subtype 'Policy paper'

    scrapable true

    factory :content_type_with_no_subtype do
      subtype nil
    end

    factory :unscrapable_content_type do
      type 'Corporate information'
      subtype 'Personal information charter'

      scrapable false
    end
  end
end
