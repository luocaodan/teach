# frozen_string_literal: true

class IssuesService < BaseService
  def all(params = {})
    # pagination
    params[:scope] = 'all'
    project_id = params.delete 'project'
    milestone_id = params.delete 'milestone_id'
    issue_list, gitlab_headers = get_with_headers "projects/#{project_id}/issues", params
    add_external_field issue_list
    records = if milestone_id
                Issue.where(milestone_id: milestone_id)
              else
                Issue.where(project_id: project_id)
              end
    total_weight = records.sum { |r| r.weight.to_i }
    todos = records.where(state: 'To Do')
    todo_total = todos.count
    todo_total_weight = todos.sum { |r| r.weight.to_i }
    doings = records.where(state: 'Doing')
    doing_total = doings.count
    doing_total_weight = doings.sum { |r| r.weight.to_i }
    dones = records.where(state: 'Closed')
    done_total = dones.count
    done_total_weight = dones.sum { |r| r.weight.to_i }
    issue_list.each do |issue|
      update_issue_time issue
    end
    {
      issues: issue_list,
      total: gitlab_headers[:x_total].to_i,
      total_weight: total_weight,
      todo_total: todo_total,
      todo_total_weight: todo_total_weight,
      doing_total: doing_total,
      doing_total_weight: doing_total_weight,
      done_total: done_total,
      done_total_weight: done_total_weight,
      next: gitlab_headers[:x_next_page].to_i
    }
  end

  def new_issue(project_id, params = {})
    weight = params.delete :weight
    priority = params.delete :priority
    issue = post "projects/#{project_id}/issues", params
    if weight || priority
      Issue.create id: issue['id'], weight: weight, priority: priority
    end
    add_external_field [issue]
    update_issue_time issue
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
      state_flag = false
      if attr == 'state'
        if value.include?('To Do') || value.include?('Doing')
          attr = 'labels'
          value = value.join ','
          state_flag = true
        else
          attr = 'state_event'
          value = value == 'Open' ? 'reopen' : 'close'
        end
      end
      payload = {attr => value}
      payload[:labels] = 'To Do' if attr == 'state_event' && value == 'reopen'
      payload[:state_event] = 'reopen' if state_flag
      issue = put "projects/#{project_id}/issues/#{iid}", payload
    end
    add_external_field [issue]
    update_issue_time issue
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

      add_state issue
    end
  end

  def add_state(issue)
    todo = issue['labels'].delete 'To Do'
    doing = issue['labels'].delete 'Doing'
    issue['state'] = if issue['state'] != 'closed'
                       if doing
                         'Doing'
                       elsif todo
                         'To Do'
                       else
                         'Open'
                       end
                     else
                       'Closed'
                     end
  end

  private

  def project_service
    ProjectsService.new user
  end

  def update_issue_time(issue)
    issue_record = Issue.find_by(id: issue['id'])
    return unless issue_record
    issue['updated_at'] = issue_record.updated_at
  end
end