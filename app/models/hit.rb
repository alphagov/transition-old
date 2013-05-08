class Hit < ActiveRecord::Base
  belongs_to :host
  validates :host, :count, :hit_on, :path, presence: true
end
