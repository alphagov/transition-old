FactoryGirl.define do
  factory :cic_regulator, class: :site do
    site 'cic_regulator'
    homepage 'https://www.gov.uk/government/organisations/cic-regulator'

    association :organisation, factory: :dfid
  end

  factory :natural_england_site, class: :site do
    site 'naturalengland'
    homepage 'https://www.gov.uk/government/organisations/natural-england'

    association :organisation, factory: :dfid
  end
end
