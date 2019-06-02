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
      info[:milestones] = project_service.all_milestones project['id']
      infos << info
    end
    data['projects'] = infos.to_json
    data['issues-endpoint'] = issues_url(format: :json)
    data
  end

  def ie_svg_meta_tag
    tag('meta', 'http-equiv': 'X-UA-Compatible', content: 'IE=11').html_safe
  end
end
