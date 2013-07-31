class CreateRawQueryParts < ActiveRecord::Migration
  def change
    create_table :raw_query_parts do |t|
      t.string :key
      t.string :value

      t.belongs_to :raw_url
    end

    add_index :raw_query_parts, :key
    add_index :raw_query_parts, :raw_url_id
  end
end
