require 'transition/import/urls'

namespace :user_needs do
  desc 'seed sample user needs for an organisation'
  task :seed_user_needs, [:org_abbr] => :environment do |t, args|
    org = Organisation.find_by_abbr!(args[:org_abbr])
    UserNeed.find_or_create_by_name_and_organisation_id(name: 'I need to renew my passport', organisation_id: org.id)
    UserNeed.find_or_create_by_name_and_organisation_id!(name: "I need to renew my driver's license", organisation_id: org.id)
    UserNeed.find_or_create_by_name_and_organisation_id!(name: 'I need to know about maternity entitlement', organisation_id: Organisation.first.id)
  end
end
