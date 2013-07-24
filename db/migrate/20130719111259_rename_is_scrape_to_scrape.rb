class RenameIsScrapeToScrape < ActiveRecord::Migration
  def change
    rename_column :urls, :is_scrape, :for_scraping
  end
end
