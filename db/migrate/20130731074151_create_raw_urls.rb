class CreateRawUrls < ActiveRecord::Migration
  def change
    create_table :raw_urls do |t|
      t.string :url, limit: 4096, null: false
      t.string :host, null: false
      t.string :path, length: 767, null: false
      t.string :extension
      t.string :query, limit: 2048

      t.timestamps
    end

    add_index :raw_urls, :path
    add_index :raw_urls, :host
    add_index :raw_urls, :query
  end
end
