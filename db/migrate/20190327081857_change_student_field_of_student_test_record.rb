class ChangeStudentFieldOfStudentTestRecord < ActiveRecord::Migration[5.2]
  def change
    remove_column :student_test_records, :student, :string
    add_reference :student_test_records, :user, foreign_key: true
  end
end
