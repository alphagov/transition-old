class AugmentNeeds < ActiveRecord::Migration
  def change
    add_column :user_needs, :as_a, :text
    add_column :user_needs, :i_want_to, :text
    add_column :user_needs, :so_that, :text

    # See https://www.pivotaltracker.com/s/projects/860575/stories/53874011
    # for background
    add_column :user_needs, :needotron_id, :integer

    add_index :user_needs, :needotron_id
  end
end
