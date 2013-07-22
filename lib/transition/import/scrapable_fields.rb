module Transition
  module Import
    class ScrapableFields
      def self.seed!
        title   = ScrapableField.where(name: 'title', type: 'string').first_or_create!
        summary = ScrapableField.where(name: 'summary', type: 'string').first
        summary.update_attribute(:type, 'text') if summary
        summary = ScrapableField.where(name: 'summary', type: 'text').first_or_create!
        body    = ScrapableField.where(name: 'body', type: 'text').first_or_create!
        published_date = ScrapableField.where(name: 'published_date', type: 'date').first_or_create!

        ContentType.where(type: 'Detailed guide').first!.tap do |type|
          type.scrapable_fields = [title, summary, body, published_date]
          type.save!
        end

        ['Press release', 'News story', 'Government response'].each do |content_type|
          ContentType.where(type: 'News article', subtype: content_type).first!.tap do |type|
            type.scrapable_fields = [title, summary, body, published_date]
            type.save!
          end
        end
      end
    end
  end
end