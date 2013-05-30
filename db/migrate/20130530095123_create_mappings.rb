class CreateMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|
      t.references :site, null: false
      t.string :path, null: false, limit: 1024
      t.string :path_hash, null: false, limit: 40
      t.string :http_status, null: false, limit: 3
      t.text :new_url
      t.text :suggested_url
      t.text :archive_url

      t.timestamps
    end

    add_index :mappings, [:site_id]
    add_index :mappings, [:site_id, :http_status]
    add_index :mappings, [:site_id, :path_hash], unique: true
  end
end
