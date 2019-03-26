class AddTeamProjectSubgroupIdToClassroom < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :team_project_subgroup_id, :integer
  end
end
