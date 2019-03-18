class CreateStudentTestRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :student_test_records do |t|
      t.integer :project_id
      t.string :student
      t.string :score
      t.string :unittest

      t.timestamps
    end
  end
end
