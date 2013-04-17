class Abbr < ActiveRecord::Migration
  def change
    change_table :organisations do |t|
      t.rename :ackronym, :abbr
    end
    add_index :organisations, [:abbr], unique: true
  end
end
