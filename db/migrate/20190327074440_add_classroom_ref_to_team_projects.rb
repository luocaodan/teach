class AddClassroomRefToTeamProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :team_projects, :classroom, foreign_key: true
  end
end
