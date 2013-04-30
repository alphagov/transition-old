class AddCss < ActiveRecord::Migration
  def change
    change_table :organisations do |t|
      t.string :css
    end
  end
end
