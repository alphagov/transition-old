class CreateRawImportedFiles < ActiveRecord::Migration
  def change
    create_table :raw_imported_files do |t|
      t.string :fullpath
      t.integer :urls_seen

      t.timestamps
    end

    add_index :raw_imported_files, :fullpath
  end
end
