module ApplicationHelper
  include ::GitlabApi

  def projects_data
    data = {}
    data['gitlabHost'] = gitlab_host
    return data if teacher?
    project_service = ProjectsService.new current_user
    # 最小为开发者权限
    projects = project_service.all(simple: false, membership: true, min_access_level: 30)
    infos = []
    projects.each do |project|
      info = {
        id: project['id'],
        name: project['name'],
        name_with_namespace: project['name_with_namespace'],
        web_url: project['web_url']
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
    data
  end
end
