require 'test_helper'

class StudentTestRecordTest < ActiveSupport::TestCase

  test "should not save without auto_test_project_id" do
    record = StudentTestRecord.new
    assert_not record.save
  end

  auto_test_project = AutoTestProject.first

  test "should not save without user_id" do
    record = auto_test_project.student_test_records.new
    assert_not record.save
  end

  user = User.first

  test "should not save without project_id" do
    record = auto_test_project.student_test_records.new user_id: user.id
    assert_not record.save
  end


  test "should not save with exist project_id" do
    record = auto_test_project.student_test_records.new user_id: user.id, project_id: 1
    assert_not record.save
  end


  test "should save with other project_id" do
    record = auto_test_project.student_test_records.new user_id: user.id, project_id: 3
    assert record.save
  end
end
