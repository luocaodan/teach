class AddRequiredFieldToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :state, :string
    add_column :issues, :project_id, :integer
    add_column :issues, :milestone_id, :integer
  end
end
