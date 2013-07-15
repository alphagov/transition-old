class UrlGroup < ActiveRecord::Base

  # validations
  validates :name, uniqueness: {scope: :organisation_id, case_sensitive: false}
  validates :url_group_type, :organisation, presence: true

  # relationships
  belongs_to :url_group_type
  belongs_to :organisation
  has_many :urls, dependent: :restrict

  # scopes
  scope :for_organisation, ->(organisation) { where(organisation_id: organisation.id).order(:name) }

end
