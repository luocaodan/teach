module ApplicationHelper
  include ::GitlabApi

  def projects_data
    data = {}
    project_service = ProjectsService.new current_user
    projects = project_service.all(simple: false)
    infos = []
    projects.each do |project|
      info = {
        id: project['id'],
        name: project['name'],
        web_url: project['web_url'],
        # own 字段暂时废弃
        own: project['owner']['id'] == current_user.id
      }
      members = project_service.all_members project['id']
      editable = members.any? do |member|
        member[:id] == current_user.id && member.delete(:access) == 'edit'
      end
      info[:is_member] = editable
      info[:access] = if editable
                        'edit'
                      else
                        'new'
                      end
      info[:members] = members
      info[:labels] = project_service.all_labels project['id']
      info[:milestones] = project_service.all_milestones project['id']
      infos << info
    end
    data['projects'] = infos.to_json
    data['gitlabHost'] = gitlab_host
    # user = {
    #   id: current_user.id,
    #   username: current_user.username,
    #   name: current_user.name,
    #   avatar_url: current_user.avatar_url,
    #   web_url: current_user.web_url
    # }
    # data['current-user'] = user.to_json
    data
  end
end
