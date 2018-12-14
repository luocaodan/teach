require 'net/http'
require 'json'

module GitlabApi
  def get_api_url(url)
    "#{Constant::GitLabHost}/api/v4/#{url}"
  end

  def api_post(url, options = {})
    data = options[:data]
    return {} unless data

    url = get_api_url(url)
    uri = URI.parse(url)
    req = ::Net::HTTP::Post.new(uri)
    handle_headers req
    req.body = data.to_json
    res = ::Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request req
    end
    res.body
  end

  def webhook_url
    Constant::WebhookUrl
  end

  def private_token
    Constant::PRIVATE_TOKEN
  end

  def handle_headers(req)
    req['Content-Type'] = 'application/json'
    req['PRIVATE-TOKEN'] = private_token
  end

end