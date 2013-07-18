class CreateScrapeResults < ActiveRecord::Migration
  def change
    create_table :scrape_results do |t|
      t.text :data
      t.integer :scrapable_id, null: false
      t.string  :scrapable_type, null: false, length: 20

      t.timestamps
    end

    change_column :scrape_results, :data, :text, :limit => 16777215
    add_index :scrape_results, [:scrapable_id, :scrapable_type]
  end
end
