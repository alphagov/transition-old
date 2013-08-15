class RemoveFurlFromSites < ActiveRecord::Migration
  def up
    remove_column :sites, :furl
  end

  def down
    add_column :sites, :furl, :string
  end
end
