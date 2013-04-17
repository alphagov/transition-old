class Organisation < ActiveRecord::Base
  has_many :sites

  def to_param
    abbr
  end
end
