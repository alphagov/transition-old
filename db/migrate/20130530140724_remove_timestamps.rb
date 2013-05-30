class RemoveTimestamps < ActiveRecord::Migration
  def change
    remove_column :hits, :created_at
    remove_column :hits, :updated_at

    remove_column :totals, :created_at
    remove_column :totals, :updated_at

    remove_column :mappings, :created_at
    remove_column :mappings, :updated_at
  end
end
