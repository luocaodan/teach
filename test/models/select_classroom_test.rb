require 'test_helper'

class SelectClassroomTest < ActiveSupport::TestCase
  test "should not save without classroom_id" do
    sc = SelectClassroom.new
    assert_not sc.save
  end

  classroom = Classroom.first

  test "should not save without user_id" do
    sc = classroom.select_classrooms.new
    assert_not sc.save
  end

  user = User.first

  test "should save with classroom_id and user_id" do
    sc = classroom.select_classrooms.new user_id: user.id
    assert sc.save
  end
end
