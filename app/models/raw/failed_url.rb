class Raw::FailedUrl < ActiveRecord::Base
  attr_accessible :failure, :raw_imported_file_id, :url
end
