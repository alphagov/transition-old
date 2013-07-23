class ContentType < ActiveRecord::Base
  DETAILED_GUIDE = 'Detailed guide'
  attr_accessible :mandatory_url_group, :user_need_required, :scrapable, :subtype, :type

  # relationships
  has_many :urls, dependent: :restrict
  has_and_belongs_to_many :scrapable_fields

  # validations
  validates_presence_of :type
  validates_uniqueness_of :subtype, scope: :type, case_sensitive: false

  # scopes
  scope :for_site, ->(site) { select('distinct content_types.*').joins(:urls).where('urls.site_id = ?', site.id).order(:type) }

  def to_s
    [type, subtype.presence].compact.join(' / ')
  end

  def ContentType.inheritance_column
    'is_not_in_use'
  end

  def detailed_guide?
    type == DETAILED_GUIDE
  end
end
