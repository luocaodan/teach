module ApplicationHelper
  include ::GitlabApi

  def projects_data
    data = {}
    project_service = ProjectsService.new current_user
    data['projects'] = project_service
                       .all(simple: true)
                       .map { |i| { id: i['id'], name: i['name'] }}
                       .to_json
    data['gitlabHost'] = gitlab_host
    data
  end
end
