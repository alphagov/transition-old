class AddScrapeFinishedToUrls < ActiveRecord::Migration
  def up
    add_column :urls, :scrape_finished, :boolean, null: false, default: false
  end

  def down
    remove_column :urls, :scrape_finished
  end
end
