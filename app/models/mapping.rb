require 'digest/sha1'
class Mapping < ActiveRecord::Base
  belongs_to :site
  validates :site, presence: true
  validates :path, presence: true, length: { maximum: 1024 }
  validates :http_status, presence: true, length: { maximum: 3 }
  validates :site_id, uniqueness: { scope: [:path], message: 'Mapping already exists for this site and path!' }, unless: -> { Mapping.leave_uniqueness_check_to_db? }

  # set a hash of the path because we can't have a unique index on
  # the path (it's too long)
  before_validation :set_path_hash
  validates :path_hash, presence: true

  validates :new_url, :suggested_url, :archive_url, length: { maximum: (64.kilobytes - 1) }

  def self.leave_uniqueness_check_to_db?
    @leave_uniqueness_check_to_db || false
  end
  def self.leave_uniqueness_check_to_db=(new_value)
    @leave_uniqueness_check_to_db = !!new_value
  end

  def self.with_status(status)
    if status == 'all'
      scoped
    else
      scoped.where(http_status: status)
    end
  end

  protected
  def set_path_hash
    self.path_hash = Digest::SHA1.hexdigest(self.path) if self.path_changed?
  end
end
