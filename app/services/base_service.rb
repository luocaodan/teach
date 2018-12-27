class BaseService
  include ::GitlabApi
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def user_id
    @user.id
  end

  def user_token
    @user.token
  end

  def get(url, params = {})
    user_api_get url, user_token, params
  end

  def post(url, params)
    user_api_post url, user_token, params
  end

  def put(url, params)
    user_api_put url, user_token, params
  end
end