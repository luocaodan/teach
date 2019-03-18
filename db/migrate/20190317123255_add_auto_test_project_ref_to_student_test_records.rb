class AddAutoTestProjectRefToStudentTestRecords < ActiveRecord::Migration[5.2]
  def change
    add_reference :student_test_records, :auto_test_project, foreign_key: true
  end
end
