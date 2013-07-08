class Url < ActiveRecord::Base
  include Workflow

  belongs_to :site

  # validations
  validates :url, uniqueness: {case_sensitive: false}
  validates :site, presence: true

  def next
    Url.where('id > ?', id).order('id ASC').first
  end
end
