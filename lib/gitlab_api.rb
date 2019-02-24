module GitlabApi
  def get_api_url(url)
    "#{gitlab_host}/api/v4/#{url}"
  end

  def admin_api_post(url, payload)
    url = get_api_url url
    Http.json_post url, payload, admin_headers
  end

  def user_api_get(url, token, params = {})
    url = get_api_url url
    Http.json_get url, user_headers(token).merge!(params: params)
  end

  def user_api_plain_get(url, token, params = {})
    url = get_api_url url
    Http.get url, user_headers(token).merge!(params: params)
  end

  def user_api_post(url, token, payload)
    url = get_api_url url
    Http.json_post url, payload, user_headers(token)
  end

  def user_api_multipart(url, token, data)
    url = get_api_url url
    Http.multipart_post url, data, user_headers(token)
  end

  def user_api_put(url, token, payload)
    url = get_api_url url
    Http.json_put url, payload, user_headers(token)
  end

  def user_auth(access_code)
    parameters = {
      'client_id': app_id,
      'client_secret': app_secret,
      'code': access_code,
      'grant_type': 'authorization_code',
      'redirect_uri': redirect_uri
    }
    res = Http.json_post access_token_url, parameters
    res['access_token']
  end

  def gitlab_host
    Constant::GitLabHost
  end

  private

  def admin_headers
    {
      'PRIVATE-TOKEN': private_token
    }
  end

  def user_headers(token)
    {
      'Authorization': "Bearer #{token}"
    }
  end

  # constant mapping

  def webhook_url
    Constant::WebhookUrl
  end

  def access_token_url
    Constant::ACCESS_TOKEN_URL
  end

  def private_token
    Constant::PRIVATE_TOKEN
  end

  def app_id
    Constant::APP_ID
  end

  def app_secret
    Constant::APP_SECRET
  end

  def redirect_uri
    Constant::REDIRECT_URI
  end
end