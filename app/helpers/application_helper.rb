module ApplicationHelper
  include ::GitlabApi

  def projects_data
    data = {}
    project_service = ProjectsService.new current_user
    projects = project_service
                 .all(simple: true)
                 .map {|i| {id: i['id'], name: i['name']}}
    infos = []
    projects.each do |project|
      access = project_service.member_access project[:id], current_user.id
      infos << {
        id: project[:id],
        name: project[:name],
        access: access
      }
    end
    data['projects'] = infos.to_json
    data['gitlabHost'] = gitlab_host
    data
  end
end
