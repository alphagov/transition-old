require 'digest/sha1'
class Hit < ActiveRecord::Base
  NEVER = Date.new(1970)

  belongs_to :host
  validates :host, :hit_on, presence: true
  validates :path, presence: true, length: { maximum: 1024 }
  validates :count, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :http_status, presence: true, length: { maximum: 3 }
  validates :host_id, uniqueness: { scope: [:path, :hit_on, :http_status], message: 'Hit data already exists for this host, path, date and status!' }, unless: -> { Hit.leave_uniqueness_check_to_db? }

  # set a hash of the path because we can't have a unique index on
  # the path (it's too long)
  before_validation :set_path_hash
  before_validation :normalize_hit_on
  validates :path_hash, presence: true

  def self.leave_uniqueness_check_to_db?
    @leave_uniqueness_check_to_db || false
  end
  def self.leave_uniqueness_check_to_db=(new_value)
    @leave_uniqueness_check_to_db = !!new_value
  end

  def self.top_100
    scoped.limit(100).order('count desc')
  end

  def self.aggregated
    scoped.select('hits.path, sum(hits.count) as count, hits.http_status, hits.hit_on').group(:path, :http_status, :hit_on)
  end

  def self.from_aggregate(aggregated_scope)
    Hit.unscoped.from(%{(#{aggregated_scope.to_sql}) as aggregated_hits})
  end

  def self.without_zero_status_hits
    scoped.where('http_status NOT IN ("0", "00", "000")')
  end

  def self.in_count_order
    scoped.order('count desc').order(:http_status, :path).order('hit_on desc')
  end

  def self.unique_pages_and_statuses
    scoped.select('hits.host_id, hits.path, sum(hits.count) as count, hits.http_status').group(:host_id, :path, :http_status)
  end

  def self.most_recent_hit_on_date(opts = {})
    opts = {
      from_aggregate: false,
      fallback_date: Date.today
    }.merge(opts)
    if opts[:from_aggregate]
      Hit.from_aggregate(scoped).maximum('aggregated_hits.hit_on') || opts[:fallback_date]
    else
      scoped.maximum(:hit_on) || opts[:fallback_date]
    end
  end

  def self.most_recent_hits(hit_on_date = most_recent_hit_on_date)
    scoped.where(hit_on: hit_on_date.beginning_of_day.to_date)
  end
  
  def self.in_date_range(start_date, end_date)
    scoped.where(hit_on: start_date.beginning_of_day...end_date.end_of_day)
  end

  def self.most_hits(opts = {})
    opts = {from_aggregate: false}.merge(opts)
    if opts[:from_aggregate]
      Hit.from_aggregate(scoped).maximum('aggregated_hits.count')
    else
      scoped.maximum(:count)
    end
  end

  def self.counts_by_status(opts = {})
    opts = {from_aggregate: false}.merge(opts)
    if opts[:from_aggregate]
      Hit.from_aggregate(scoped).group('aggregated_hits.http_status').sum('aggregated_hits.count')
    else
      scoped.group(:http_status).sum(:count)
    end
  end

  def self.total_hits(opts = {})
    opts = {from_aggregate: false}.merge(opts)
    if opts[:from_aggregate]
      Hit.from_aggregate(scoped).sum('aggregated_hits.count')
    else
      scoped.sum(:count)
    end
  end

  def self.with_status(status)
    if status == 'all'
      scoped
    else
      scoped.where(http_status: status)
    end
  end

  def prep_for_import
    set_path_hash
    normalize_hit_on
  end
  protected
  def set_path_hash
    self.path_hash = Digest::SHA1.hexdigest(path) if path_changed?
  end
  def normalize_hit_on
    self.hit_on = hit_on.beginning_of_day if hit_on_changed?
  end
end
