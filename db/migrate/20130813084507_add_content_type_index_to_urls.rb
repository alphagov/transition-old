class AddContentTypeIndexToUrls < ActiveRecord::Migration
  def change
    add_index :urls, :content_type_id
  end
end
