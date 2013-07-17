class CreateScrapableFields < ActiveRecord::Migration
  def change
    create_table :scrapable_fields do |t|
      t.string :name
      t.string :type

      t.timestamps
    end

    create_table :content_types_scrapable_fields do |t|
      t.integer :content_type_id
      t.integer :scrapable_field_id
    end

    add_index :content_types_scrapable_fields, [:scrapable_field_id, :content_type_id],
              unique: true,
              name: :index_content_type_scrapable_field
  end
end
