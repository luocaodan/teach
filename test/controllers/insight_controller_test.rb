require 'test_helper'

class InsightControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    team_project = team_projects(:one)
    get classroom_team_project_insight_url(classroom_id: team_project.classroom.id, team_project_id: team_project.id, format: :json), params: params
    assert_equal 'show', @controller.action_name
  end

  private

  def params
    {
        from: '2019-01-01',
        to: '2019-01-02'
    }
  end
end
