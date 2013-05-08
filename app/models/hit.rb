require 'digest/sha1'
class Hit < ActiveRecord::Base
  belongs_to :host
  validates :host, :hit_on, presence: true
  validates :path, presence: true, length: { maximum: 1024 }
  validates :count, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :http_status, presence: true, length: { maximum: 3 }
  validates :host_id, uniqueness: { scope: [:path, :hit_on, :http_status], message: 'Hit data already exists for this host, path, date and status!' }

  # set a hash of the path because we can't have a unique index on
  # the path (it's too long)
  before_validation :set_path_hash
  validates :path_hash, presence: true

  def set_path_hash
    self.path_hash = Digest::SHA1.hexdigest(self.path) if self.path_changed?
  end
end
