class AddMandatoryUrlGroupToContentTypes < ActiveRecord::Migration
  def up
    add_column :content_types, :mandatory_url_group, :boolean, null: false, default: false
  end

  def down
    remove_column :content_types, :mandatory_url_group
  end
end
