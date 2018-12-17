require 'set'

class ProjectsService < BaseService
  def project(project_id)
    get("projects/#{project_id}")
  end

  def all(params = {})
    params[:membership] = true
    get('projects', params)
  end

  def all_members()
    members = Set.new([])
    projects = all(simple: true).map { |i| i['id'] }
    projects.each do |project_id|
      list = get("projects/#{project_id}/members")
      list.each do |member|
        members << {
          id: member['id'],
          name: member['name'],
          avatar: member['avatar_url']
        }
      end
    end
    members.to_a
  end

  def all_labels
    labels = Set.new([])
    projects = all(simple: true).map { |i| i['id'] }
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