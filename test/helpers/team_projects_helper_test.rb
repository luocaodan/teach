require 'test_helper'

class TeamProjectsHelperTest < ActionView::TestCase
  setup do
    @c_id = classrooms(:one).id
    @t_id = team_projects(:one).id
  end

  test "helpers" do
    begin
      classroom_path_team_project_prefix
    rescue Errno::ECONNREFUSED
    end
    assert true
  end

  private

  def params
    {classroom_id: @c_id,
     team_project_id: @t_id}
  end

  def current_user
    Session.new 1, 'token', 'name'
  end
end