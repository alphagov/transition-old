class Raw::ImportedFile < ActiveRecord::Base
  attr_accessible :fullpath, :urls_seen
end
