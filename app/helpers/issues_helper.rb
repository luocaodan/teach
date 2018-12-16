module IssuesHelper
  def issues_data
    {
      endpoint: issues_url(format: :json)
    }
  end
end
