class ChangeUserNeedsColumns < ActiveRecord::Migration
  def up
    change_column :user_needs, :needotron_id, :string
  end

  def down
    change_column :user_needs, :needotron_id, :integer
  end
end
