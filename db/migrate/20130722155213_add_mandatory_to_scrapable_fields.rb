class AddMandatoryToScrapableFields < ActiveRecord::Migration
  def up
    add_column :scrapable_fields, :mandatory, :boolean, null: false, default: false
  end

  def down
    remove_column :scrapable_fields, :mandatory
  end
end
