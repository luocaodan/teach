class AddClassroomRefToAutoTestProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :auto_test_projects, :classroom, foreign_key: true
  end
end
