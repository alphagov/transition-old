class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.references :organisation
      t.string :site
      t.string :query_params
      t.timestamp :tna_timestamp
      t.string :homepage
      t.string :furl

      t.timestamps
    end
    add_index :sites, [:site], unique: true
  end
end
