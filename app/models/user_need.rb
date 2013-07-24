class UserNeed < ActiveRecord::Base
  ARBITRARY_NEEDOTRON_ID_GAP = 5000
  after_create :assign_needotron_id

  # relationships
  belongs_to :organisation

  # validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  private

  def assign_needotron_id
    update_attribute(:needotron_id, id + ARBITRARY_NEEDOTRON_ID_GAP)
  end
end
