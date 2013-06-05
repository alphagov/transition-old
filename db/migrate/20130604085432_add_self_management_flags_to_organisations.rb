class AddSelfManagementFlagsToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :manages_own_redirects, :boolean, null: false, default: false
  end
end
