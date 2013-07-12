class AddContentTypeToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :content_type, :string
  end
end
