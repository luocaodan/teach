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
        full_project = get_project project_id
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
      student = sr.user
      next if student? && student.gitlab_id != current_user.id
      project_id = sr.project_id
      project_url = get_project(project_id)['web_url']
      pipeline_status = 'stop'
      if sr.pipeline_id
        pipeline = get_pipeline project_id, sr.pipeline_id
        pipeline_status = if %w[running pending].include? pipeline['status']
                            'running'
                          end
      end
      records << {
        id: sr.id,
        student: student.username,
        score: sr.score,
        unittest: sr.unittest,
        feedback: sr.feedback,
        project_id: sr.project_id,
        project_url: project_url,
        editable: teacher?,
        status: pipeline_status
      }
    end
    records.to_json
  end

  private

  def project_forks(parent_project_id, params)
    admin_api_get "projects/#{parent_project_id}/forks", params
  end

  def get_project(project_id)
    admin_api_get "projects/#{project_id}"
  end

  def get_pipeline(project_id, pipeline_id)
    admin_api_get "projects/#{project_id}/pipelines/#{pipeline_id}"
  end
end
