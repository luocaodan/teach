require 'json'

module IssuesHelper
  def issues_data
    {
      endpoint: issues_url(format: :json)
    }
  end

  def filter_data
    # 废弃
    # data = {
    #   projects: [],
    # }
    # project_service = ProjectsService.new current_user
    # projects = project_service.all(simple: true)
    # projects.each do |project|
    #   data[:projects] << { id: project['id'], name: project['name'] }
    # end
    # data[:members] = project_service.all_members.to_json
    # data[:labels] = project_service.all_labels.to_json
    # data[:projects] = data[:projects].to_json
    #
    # data
  end
end
