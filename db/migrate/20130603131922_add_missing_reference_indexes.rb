class AddMissingReferenceIndexes < ActiveRecord::Migration
  def change
    add_index :hosts, :site_id

    add_index :sites, :organisation_id
  end
end
