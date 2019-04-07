class AddPiplineIdToStudentTestRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :student_test_records, :pipeline_id, :integer
  end
end
