class CreateContentTypes < ActiveRecord::Migration
  def change
    create_table :content_types do |t|
      t.string :type
      t.string :subtype
      t.boolean :scrapable

      t.timestamps
    end
    add_index :content_types, [:type, :subtype], unique: true
  end
end
