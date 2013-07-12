class AddIsScrapeToUrls < ActiveRecord::Migration
  def change
    change_table :urls do |t|
      t.boolean :is_scrape
    end
  end
end
