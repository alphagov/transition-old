class AddPositionToContentTypes < ActiveRecord::Migration
  def up
    add_column :content_types, :position, :integer
    add_index :content_types, :position
  end

  def down
    remove_index :content_types, :position
    remove_column :content_types, :position
  end
end
