module DailyScrumsHelper
  def daily_scrums_data
    # todo
    {
      endpoint: daily_scrum_url(format: :json),
      list: list
    }
  end
end
