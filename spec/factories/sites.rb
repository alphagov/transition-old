FactoryGirl.define do
  factory :cic_regulator, class: :site do
    site 'cic_regulator'
    furl 'www.gov.uk/cic-regulator'
    homepage 'https://www.gov.uk/government/organisations/cic-regulator'
  end

  factory :natural_england_site, class: :site do
    site 'naturalengland'
    furl 'www.gov.uk/natural-england'
    homepage 'https://www.gov.uk/government/organisations/natural-england'

    association :organisation, factory: :dfid
  end
end
