class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.references :host, null: false
      t.string :path, null: false
      t.string :http_status, null: false
      t.integer :count, null: false
      t.date :hit_on, null: false

      t.timestamps
    end

    add_index :hits, [:host_id]
    add_index :hits, [:host_id, :hit_on]
    add_index :hits, [:host_id, :http_status]
  end
end
