FactoryGirl.define do
  factory :scrapable_field do
    name 'title'
    type 'string'
  
    factory :scrapable_field_title do
    end

    factory :scrapable_field_body do
      name 'body'
      type 'text'    
    end
  end
end