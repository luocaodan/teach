require 'test_helper'

class AutoTestProjectTest < ActiveSupport::TestCase
  test "should not save without classroom_id" do
    p = AutoTestProject.new
    assert_not p.save
  end

  classroom = Classroom.first

  test "should not save without gitlab_id" do
    p = classroom.auto_test_projects.new
    assert_not p.save
  end

  test "should not save with exist gitlab_id" do
    p = classroom.auto_test_projects.new gitlab_id: 1
    assert_not p.save
  end

  test "should save" do
    p = classroom.auto_test_projects.new gitlab_id: 3
    assert p.save
  end
end
