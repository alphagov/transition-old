class CreateWorkflowState < ActiveRecord::Migration
  def change
    add_column :urls, :workflow_state, :string, null: false, default: 'new'
  end
end
