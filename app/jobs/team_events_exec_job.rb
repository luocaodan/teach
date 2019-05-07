class TeamEventsExecJob < ApplicationJob
  queue_as :default

  # 限时 100 ms
  EVENT_TIME_OUT = 100

  # 内存最大 1Mb
  MAX_MEMORY = 1_000_000

  def perform(team_project_ids, team_events)
    # run all team_events for team in teams
    # team_project_ids: team_project active record id list
    # team_events: team_event active record list
    event_errors = Array.new team_events.length, false
    team_project_ids.each do |team_project_id|
      contribution_service = ContributionService.new team_project_id
      issues = nil
      weights = nil
      commits = nil
      team_events.each_with_index do |team_event, index|
        next if event_errors[index]
        team_state = TeamState.find_or_create_by(
          team_project_id: team_project_id,
          team_event_id: team_event.id
        )
        code = team_event.code
        ctx = MiniRacer::Context.new timeout: EVENT_TIME_OUT, max_memory: MAX_MEMORY
        begin
          ctx.eval code
          func_str = ctx.eval 'event.toString()'
          deps = /function event\(([^)]*)/.match func_str
          deps = deps ? deps[1].split(/\s*,\s*/) : []
          # 注入依赖
          deps.each do |dep|
            case dep
            when 'commits'
              commits ||= contribution_service.commits_data
              ctx.eval "const commits = JSON.parse('#{commits.to_json}')"
            when 'issues'
              issues ||= contribution_service.issues_data
              ctx.eval "const issues = JSON.parse('#{issues.to_json}')"
            when 'weights'
              weights ||= contribution_service.weight_data
              ctx.eval "const weights = JSON.parse('#{weights.to_json}')"
            end
          end
          # 贡献数据为空，标记默认状态
          if commits&.length&.zero? || issues&.length&.zero? || weights&.length&.zero?
            team_state.update state: '暂无 Commit 或 Issues 数据'
            next
          end
          # 执行
          state = ctx.eval "event(#{deps.join(',')})"
          team_state.update state: state
          team_event.update error: nil
        rescue MiniRacer::RuntimeError => e
          event_errors[index] = true
          team_event.update error: e.message
        end
      end
    end
  end
end