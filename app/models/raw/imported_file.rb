module Raw
  class ImportedFile < ActiveRecord::Base
    attr_accessible :fullpath, :urls_seen

    has_many :failed_urls, class_name: 'Raw::FailedUrl'
  end
end