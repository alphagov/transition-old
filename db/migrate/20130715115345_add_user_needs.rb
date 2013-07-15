class AddUserNeeds < ActiveRecord::Migration
  def change
    create_table :user_needs do |t|
      t.string :name, null: false
      t.integer :organisation_id

      t.timestamps
    end
    add_index :user_needs, [:organisation_id, :name]

    change_table :urls do |t|
      t.integer :user_need_id
    end
    add_index :urls, [:user_need_id]
  end
end
