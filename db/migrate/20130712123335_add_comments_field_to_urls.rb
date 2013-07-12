class AddCommentsFieldToUrls < ActiveRecord::Migration
  def change
    change_table :urls do |t|
      t.text :comments
    end
  end
end
