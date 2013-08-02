class Raw::FailedUrl < ActiveRecord::Base
  attr_accessible :failure, :raw_imported_file_id, :url, :imported_file

  belongs_to :imported_file, class_name: 'Raw::ImportedFile', foreign_key: 'raw_imported_file_id'
end
