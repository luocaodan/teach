class AddPriorityToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :priority, :integer
  end
end
