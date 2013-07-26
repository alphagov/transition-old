class AddGuidanceAndSeriesToUrls < ActiveRecord::Migration
  def up
    rename_column :urls, :url_group_id, :guidance_id
    add_column :urls, :series_id, :integer
    rename_column :content_types, :mandatory_url_group, :mandatory_guidance
  end

  def down
    rename_column :urls, :guidance_id, :url_group_id
    remove_column :urls, :series_id
    rename_column :content_types, :mandatory_guidance, :mandatory_url_group
  end
end
