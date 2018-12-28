require 'set'
require 'rest-client'

class ProjectsService < BaseService
  def project(project_id)
    get("projects/#{project_id}")
  end

  def all(params = {})
    params[:membership] = true
    get('projects', params)
  end

  def all_members(projects)
    members = Set.new([])
    # projects = all(simple: true).map { |i| i['id'] }
    projects.each do |project_id|
      list = get("projects/#{project_id}/members/all")
      list.each do |member|
        members << {
          id: member['id'],
          name: member['name'],
          avatar: member['avatar_url'],
          username: member['username']
        }
      end
    end
    members.to_a
  end

  def all_milestones(projects)
    milestones = Set.new([])
    projects.each do |project_id|
      list = get "projects/#{project_id}/milestones"
      list.each do |milestone|
        milestones << {
          id: milestone['id'],
          project_id: milestone['project_id'],
          title: milestone['title']
        }
      end
    end
    milestones.to_a
  end

  def member_access(project_id, user_id)
    begin
      res = get "projects/#{project_id}/members/#{user_id}"
      if res['access_level'] > 10
        'edit'
      else
        'new'
      end
    rescue RestClient::NotFound => e
      'new'
    end
  end

  def all_labels(projects)
    labels = Set.new([])
    # projects = all(simple: true).map { |i| i['id'] }
    projects.each do |project_id|
      list = get("projects/#{project_id}/labels")
      list.each do |label|
        labels << {
          id: label['id'],
          name: label['name']
        }
      end
    end
    labels.to_a
  end
end