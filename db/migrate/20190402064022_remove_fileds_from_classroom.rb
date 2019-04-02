class RemoveFiledsFromClassroom < ActiveRecord::Migration[5.2]
  def change
    remove_column :classrooms, :name, :string
    remove_column :classrooms, :path, :string
    remove_column :classrooms, :description, :string
  end
end
