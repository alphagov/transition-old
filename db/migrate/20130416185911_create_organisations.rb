class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.string :ackronym
      t.string :title
      t.date :launch_date
      t.string :homepage
      t.string :furl

      t.timestamps
    end
  end
end
