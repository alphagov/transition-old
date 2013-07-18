module Transition
  module Import
    class ScrapableFields
      def self.seed!
        title   = ScrapableField.where(name: 'title', type: 'string').first_or_create!
        summary = ScrapableField.where(name: 'summary', type: 'string').first_or_create!
        body    = ScrapableField.where(name: 'body', type: 'text').first_or_create!

        ContentType.where(type: 'Detailed guide').first!.tap do |type|
          type.scrapable_fields = [title, summary, body]
          type.save!
        end
      end
    end
  end
end