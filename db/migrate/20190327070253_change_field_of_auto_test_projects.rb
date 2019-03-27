class ChangeFieldOfAutoTestProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :auto_test_projects, :name, :string
    remove_column :auto_test_projects, :description, :string
    add_column :auto_test_projects, :gitlab_id, :integer
  end
end
