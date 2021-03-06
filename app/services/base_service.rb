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

  def plain_get(url, params = {})
    user_api_plain_get url, user_token, params
  end

  def get_with_headers(url, params = {})
    user_api_get_with_headers url, user_token, params
  end

  def post(url, params)
    user_api_post url, user_token, params
  end

  def multipart_post(url, params)
    user_api_multipart url, user_token, params
  end

  def put(url, params)
    user_api_put url, user_token, params
  end

  def delete(url, params = {})
    user_api_delete url, user_token, params
  end
end