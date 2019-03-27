module AutoTestProjectsHelper
  def student_test_records
    classroom = Classroom.find(params[:classroom_id])
    auto_test_project = AutoTestProject.find(params[:id])
    parent_project_id = auto_test_project.gitlab_id
    # 管理员权限列出所有fork
    student_projects = project_forks(parent_project_id, simple: true)
    # 当前存在的测试记录
    exist_records = auto_test_project.student_test_records
    student_projects.each do |project|
      project_id = project['id']
      unless exist_records.find_by(project_id: project_id)
        full_project = projects_service.project project_id
        gitlab_user_id = full_project['owner']['id']
        student = classroom.users&.find_by(gitlab_id: gitlab_user_id, role: 'student')
        next unless student
        exist_records.create(
          project_id: project_id,
          user_id: student.id
        )
      end
    end
    records = []
    exist_records.each do |sr|
      records << {
        id: sr.id,
        student: User.find(sr.user_id).username,
        score: sr.score,
        unittest: sr.unittest
      }
    end
    {
      records: records.to_json
    }
  end

  private

  def project_forks(parent_project_id, params)
    admin_api_get "projects/#{project_id}/forks", params
  end
end
