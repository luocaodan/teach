class ProjectsService < BaseService
  def project(project_id)
    get("projects/#{project_id}")
  end

  def all(params = {})
    get('projects', params)
  end

  def all_members(project_id)
    members = []
    list = get("projects/#{project_id}/members/all")
    list.each do |member|
      members << {
        id: member['id'],
        name: member['name'],
        avatar: member['avatar_url'],
        username: member['username'],
        access: member_access(member['access_level'])
      }
    end
    members
  end

  def all_milestones(project_id)
    milestones = []
    list = get "projects/#{project_id}/milestones"
    list.each do |milestone|
      milestones << {
        id: milestone['id'],
        iid: milestone['iid'],
        project_id: milestone['project_id'],
        title: milestone['title'],
        start_date: milestone['start_date'],
        due_date: milestone['due_date']
      }
    end
    milestones
  end

  def member_access(level)
    if level > 10
      'edit'
    else
      'new'
    end
  end

  def all_labels(project_id)
    labels = []
    # projects = all(simple: true).map { |i| i['id'] }
    list = get("projects/#{project_id}/labels")
    list.each do |label|
      labels << {
        id: label['id'],
        name: label['name']
      }
    end
    labels
  end
end