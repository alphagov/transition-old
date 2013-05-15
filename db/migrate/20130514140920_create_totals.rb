class CreateTotals < ActiveRecord::Migration
  def change
    create_table :totals do |t|
      t.references :host, null: false
      t.string :http_status, null: false, limit: 3
      t.integer :count, null: false
      t.date :total_on, null: false

      t.timestamps
    end

    add_index :totals, [:host_id, :total_on, :http_status], unique: true
  end
end
