class AddUrlGroups < ActiveRecord::Migration
  def change
    create_table :url_group_types do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :url_groups do |t|
      t.string :name, null: false
      t.integer :url_group_type_id, null: false
      t.integer :organisation_id, null: false

      t.timestamps
    end
    add_index :url_groups, [:organisation_id]
    add_index :url_groups, [:url_group_type_id, :organisation_id, :name], name: 'index_url_groups_on_group_type_organisation_and_name'

    change_table :urls do |t|
      t.integer :url_group_id
    end
    add_index :urls, [:url_group_id]
  end
end
