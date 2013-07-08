class Url < ActiveRecord::Base
  include Workflow

  belongs_to :site

  # validations
  validates :url, uniqueness: {case_sensitive: false}
  validates :site, presence: true

  workflow do
    state :new do
      event :archive, :transitions_to => :archived
      event :manual, :transitions_to => :manual
    end

    state :manual do
      event :redirect, :transitions_to => :redirected
    end

    state :archived         # Terminal, 410
    state :redirected       # Terminal, 301
  end

  def next
    Url.where('id > ?', id).order('id ASC').first
  end
end