class WebhookController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    event = params[:webhook]
    issue_state_handler(event)
    commit_handler(event)
    issue_finish_handler(event)
    issue_reopen_handler(event)
    render json: {status: 'success'}
  end

  private

  def issue_state_handler(event)
    # 追踪 gitlab issues 状态更新并更新数据库
    return unless is_kind?(event, :issue)
    issue = event['object_attributes']
    issue_record = Issue.find_by(id: issue['id'])
    issue_record ||= Issue.create id: issue['id']
    issue_record.project_id = event['project']['id']
    issue_record.milestone_id = issue['milestone_id']
    if issue['state'] == 'closed'
      issue_record.state = 'Closed'
    else
      labels = event['labels']
      label_titles = labels.each_with_object([]) {|l, a| a << l['title']}
      todo = label_titles.delete 'To Do'
      doing = label_titles.delete 'Doing'
      issue_record.state = if doing
                             doing
                           elsif todo
                             todo
                           else
                             'Open'
                           end
    end
    issue_record.save
  end

  def commit_handler(event)
    return unless is_kind?(event, :push)
    project_id = event['project_id']
    team_project = TeamProject.find_by(gitlab_id: project_id)
    return unless team_project

    # 如果使用 ssh push, GitLab 通过 push 用户的 ssh key 识别用户
    gitlab_user_id = event['user_id']
    user = User.find_by(gitlab_id: gitlab_user_id)
    unless user
      gitlab_user = get_user gitlab_user_id
      user ||= User.create(
        gitlab_id: gitlab_user_id, role: 'student', username: gitlab_user['username']
      )
    end

    classroom = team_project.classroom
    add_user_to_classroom classroom, user

    commits = event['commits']
    commits.each do |commit|
      # 跳过其他分支的重复 commit
      next if team_project.contribution_commits.find_by(gitlab_id: commit['id'])
      team_project.contribution_commits.create(
        gitlab_id: commit['id'], user_id: user.id,
        committed_at: commit['timestamp']
      )
    end
    # 执行事件
    TeamEventsExecJob.perform_later [team_project.id], classroom.team_events
  end

  def issue_finish_handler(event)
    return unless is_kind?(event, :issue)
    project_id = event['project']['id']
    team_project = TeamProject.find_by(gitlab_id: project_id)
    return unless team_project

    username = event['user']['username']
    user = User.find_by(username: username)
    unless user
      gitlab_user = get_user_by_username username
      user ||= User.create(
        gitlab_id: gitlab_user['id'], role: 'student', username: username
      )
    end

    classroom = team_project.classroom
    add_user_to_classroom classroom, user
    issue = event['object_attributes']
    return unless issue['state'] == 'closed'
    issue_record = Issue.find(issue['id'])
    # 防止重复 close issue
    unless issue_record.contribution_issue_id
      issue_record.contribution_issue_id = team_project.contribution_issues.create(
        user_id: user.id, closed_at: issue['updated_at']
      ).id
      issue_record.save
    end
    # 执行事件
    TeamEventsExecJob.perform_later [team_project.id], classroom.team_events
  end

  def issue_reopen_handler(event)
    # issue reopen 删除贡献记录
    return unless is_kind?(event, :issue)
    issue = event['object_attributes']
    return unless issue['state'] == 'opened'
    issue_record = Issue.find_by(id: issue['id'])
    tmp = issue_record&.contribution_issue_id
    issue_record&.contribution_issue_id = nil
    issue_record&.save
    ContributionIssue.find(tmp).destroy if tmp
  end

  def is_kind?(event, *kinds)
    kinds.each do |kind|
      return true if event['object_kind'] == kind.to_s
    end
    false
  end

  def get_user(user_id)
    admin_api_get "users/#{user_id}"
  end

  def get_user_by_username(username)
    users = admin_api_get "users?username=#{username}"
    users[0]
  end

  def add_user_to_classroom(classroom, user)
    unless classroom.users.find_by(gitlab_id: user.gitlab_id)
      classroom.users << user
    end
  end
end
