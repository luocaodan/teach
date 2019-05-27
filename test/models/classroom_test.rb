require 'test_helper'

class ClassroomTest < ActiveSupport::TestCase
  test "should not save without gitlab_gourp_id" do
    classroom = Classroom.new
    assert_not classroom.save
  end

  test "should not save with exist gitlab_group_id" do
    classroom = Classroom.new gitlab_group_id: 1
    assert_not classroom.save
  end

  test "should save with gitlab_group_id" do
    classroom = Classroom.new gitlab_group_id: 2
    assert classroom.save
    assert classroom.to_json
  end
end
