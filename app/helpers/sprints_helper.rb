module SprintsHelper
  def sprints_data
    {
      endpoint: sprints_url(format: :json)
    }
  end
end
