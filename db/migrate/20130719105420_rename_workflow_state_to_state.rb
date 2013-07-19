class RenameWorkflowStateToState < ActiveRecord::Migration
  def change
    rename_column :urls, :workflow_state, :state
  end
end
