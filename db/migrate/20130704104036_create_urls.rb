class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url, null: false, limit: 2048
      t.integer :site_id, null: false

      t.timestamps
    end

    add_index :urls, [:url]
    add_index :urls, [:site_id]
  end
end