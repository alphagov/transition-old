class AddUserNeedRequiredToContentTypes < ActiveRecord::Migration
  def change
    change_table :content_types do |t|
      t.boolean :user_need_required, default: false
    end
  end
end
