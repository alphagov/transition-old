class CreateRawFailedUrls < ActiveRecord::Migration
  def change
    create_table :raw_failed_urls do |t|
      t.string :url, :limit => 8192
      t.string :failure, :limit => 2048
      t.integer :raw_imported_file_id
    end
  end
end
