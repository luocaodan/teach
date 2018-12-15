class IssuesService < BaseService
  def initialize(user)
    @user = user
  end

  def all
    user_api_get 'issues', @user.token, scope: 'all'
  end
end