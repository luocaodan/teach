class AddPersonalAndPairSubgroupToClassroom < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :personal_project_subgroup_id, :integer
    add_column :classrooms, :pair_project_subgroup_id, :integer
  end
end
