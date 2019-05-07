class TimedTeamEventsJob < TeamEventsExecJob
  queue_as :default

  def perform(*args)
    # run all events
    classrooms = Classroom.all
    classrooms.each do |classroom|
      super classroom.team_project_ids, classroom.team_events
    end
  end
end
