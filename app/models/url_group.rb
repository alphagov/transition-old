class UrlGroup < ActiveRecord::Base

  # relationships
  belongs_to :url_group_type
  belongs_to :organisation
  has_many :guidance_urls, foreign_key: 'guidance_id', class_name: 'Url', dependent: :restrict
  has_many :series_urls, foreign_key: 'series_id', class_name: 'Url', dependent: :restrict
  has_one :scrape, :as => :scrapable, class_name: 'ScrapeResult'

  # validations
  validates :name, uniqueness: {scope: :organisation_id, case_sensitive: false}
  validates :url_group_type, :organisation, presence: true

  # scopes
  scope :for_organisation, ->(organisation) { where(organisation_id: organisation.id).order(:name) }

  # this only returns true if all 'for scraping' urls are marked as scrape_finished
  def scrape_finished?
    guidance_urls.for_scraping.all?(&:scrape_finished?)
  end

  ##
  # Here because of the +ScrapeResult+ polymorphic - needs to behave like +Url+.
  # Reliant on the assumption that all +Url+s in this group have the same +content_type+
  def content_type
    guidance_urls.for_scraping.first.try(:content_type)
  end
end
