module Transition
  class UrlGroups
    def self.seed_group_types
      [UrlGroupType::GUIDANCE, UrlGroupType::SERIES].each do |group_type|
        UrlGroupType.find_or_create_by_name(group_type)
      end
    end

    def self.seed_groups(organisation_abbr)
      org = Organisation.find_by_abbr!(organisation_abbr)
      url_group_type = UrlGroupType.find_by_name(UrlGroupType::GUIDANCE)
      org.url_groups.create!(url_group_type: url_group_type, name: 'Catchment sensitive farming')
      org.url_groups.create!(url_group_type: url_group_type, name: 'Bee health')
      url_group_type = UrlGroupType.find_by_name(UrlGroupType::SERIES)
      org.url_groups.create!(url_group_type: url_group_type, name: 'Blue badge circular')
    end
  end
end
