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
    projects = projects.collect { |p| p[:id] }
    data[:members] = project_service.all_members(projects).to_json
    data[:labels] = project_service.all_labels(projects).to_json
    data[:milestones] = project_service.all_milestones(projects).to_json
    data
  end
end
