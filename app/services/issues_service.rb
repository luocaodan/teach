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
    weight = params.delete :weight
    priority = params.delete :priority
    issue = post "projects/#{project_id}/issues", params
    if weight || priority
      Issue.create id: issue['id'], weight: weight, priority: priority
    end
    add_external_field [issue]
    issue
  end

  def update_issue(id, project_id, iid, update)
    attr = update.delete :attr
    if %w[weight priority].include? attr
      if Issue.exists? id
        issue = Issue.find id
        issue.update attr => update[:value]
      else
        Issue.create(id: id, attr => update[:value])
      end
      issue = get "projects/#{project_id}/issues/#{iid}"
    else
      value = update[:value]
      value = value.join ',' if attr == 'labels'
      attr = 'assignee_ids' if attr == 'assignee'
      attr = 'milestone_id' if attr == 'milestone'
      payload = {attr => value}
      issue = put "projects/#{project_id}/issues/#{iid}", payload
    end
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
      if Issue.exists? issue['id']
        issue_model = Issue.find issue['id']
        issue['weight'] = issue_model.weight
        issue['priority'] = issue_model.priority
      else
        issue['weight'] = nil
        issue['priority'] = nil
      end
    end
  end

  private

  def project_service
    ProjectsService.new user
  end
end