class AddUniqIndexToClassroom < ActiveRecord::Migration[5.2]
  def change
    add_index :classrooms, :name, unique: true
    add_index :classrooms, :path, unique: true
  end
end
