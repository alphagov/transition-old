class AddGlobalSiteMappings < ActiveRecord::Migration
  def change
    add_column :sites, :global_http_status, :string, limit: 3
    add_column :sites, :global_new_url, :text
  end
end
