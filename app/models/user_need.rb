class UserNeed < ActiveRecord::Base
  after_create :assign_needotron_id

  # relationships
  belongs_to :organisation

  # validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  private

  def assign_needotron_id
    update_attribute(:needotron_id, "T#{id}")
  end
end
