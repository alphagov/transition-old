FactoryGirl.define do
  factory :content_type do
    type 'Publication'
    sequence(:subtype) { |n| "Policy paper #{n}" }

    scrapable true

    factory :content_type_with_no_subtype do
      subtype nil
    end

    factory :unscrapable_content_type do
      type 'Corporate information'
      subtype 'Personal information charter'

      scrapable false
    end

    factory :scrapable_content_type do
      type               'Scrapable'
      subtype             nil
      scrapable          true
    end

    factory :detailed_guide_content_type do
      type               'Detailed guide'
      subtype             nil
      mandatory_guidance true
      scrapable          true
    end
  end
end
