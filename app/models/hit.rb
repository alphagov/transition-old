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

  def self.without_zero_status_hits
    scoped.where('http_status <> "0"')
  end

  def self.in_count_order
    scoped.order('count desc').order(:http_status, :path, :hit_on)
  end

  def self.most_recent_hit_on_date
    scoped.maximum(:hit_on)
  end

  def self.most_recent_hits(hit_on_date = most_recent_hit_on_date)
    scoped.where(hit_on: hit_on_date)
  end

  def self.most_hits
    scoped.maximum(:count)
  end

  def self.counts_by_status
    scoped.group(:http_status).sum(:count)
  end

  def self.total_hits
    scoped.sum(:count)
  end

  def set_path_hash
    self.path_hash = Digest::SHA1.hexdigest(self.path) if self.path_changed?
  end
end
