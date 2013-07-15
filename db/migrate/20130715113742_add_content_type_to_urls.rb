class AddContentTypeToUrls < ActiveRecord::Migration
  def change
    change_table :urls do |t|
      t.references :content_type
    end
  end
end
