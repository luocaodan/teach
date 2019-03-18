module AutoTestProjectsHelper
  def auto_test_projects
    @projects = AutoTestProject.all
  end

  def student_test_records
    student_projects = projects_service.forks(params[:id], simple: true)
    # 当前存在的测试记录
    auto_test_project = AutoTestProject.find(params[:id])
    exist_records = auto_test_project.student_test_records
    student_projects.each do |project|
      project_id = project['id']
      unless exist_records.find_by(project_id: project_id)
        full_project = projects_service.project project_id
        name = full_project['owner']['username']
        next unless is_student name
        exist_records.create(
          project_id: project_id,
          student: name
        )
      end
    end
    {
      records: auto_test_project.student_test_records.to_json
    }
  end

  private

  def projects_service
    ::ProjectsService.new current_user
  end

  def is_student(name)
    return false unless name.length == 8
    name.each_char do |c|
      return false if c < '0' || c > '9'
    end
    return true
  end
end
