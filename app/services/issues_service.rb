class IssuesService < BaseService
  def all(params = {})
    params[:scope] = 'all'
    project_id = params.delete 'project'
    issue_list = if !project_id.nil?
                   get "projects/#{project_id}/issues", params
                 else
                   get 'issues', params
                 end
    add_external_field issue_list
    issue_list
  end

  def new_issue(project_id, params = {})
    issue = post "projects/#{project_id}/issues", params
    add_external_field [issue]
    issue
  end

  def add_external_field(issue_list)
    map = {}
    issue_list.each do |issue|
      project_info = if map.key? issue['project_id']
                       map[issue['project_id']]
                     else
                       map[issue['project_id']] = project_service.project issue['project_id']
                     end
      issue['project_name'] = project_info['name']
      issue['weight'] = 5
      issue['priority'] = rand(3) + 1
    end
  end

  private

  def project_service
    ProjectsService.new user
  end
end