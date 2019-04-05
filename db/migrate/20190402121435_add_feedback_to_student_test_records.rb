class AddFeedbackToStudentTestRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :student_test_records, :feedback, :string
  end
end
