class UserNeed < ActiveRecord::Base
  # relationships
  belongs_to :organisation

  # validations
  validates :name, presence: true
end
