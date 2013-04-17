class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.references :site
      t.string :host
      t.integer :ttl
      t.string :cname
      t.string :live_cname

      t.timestamps
    end
    add_index :hosts, [:host], unique: true
  end
end
