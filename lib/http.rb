require 'rest-client'
require 'json'

class Http
  def self.get(url, headers = {})
    response = RestClient.get url, headers
    response.body
  end

  def self.post(url, payload, headers = {})
    response = RestClient.post(url, payload.to_json, headers)
    response.body
  end

  def self.put(url, payload, headers = {})
    response = RestClient.put(url, payload.to_json, headers)
    response.body
  end

  # post json and return json
  def self.json_post(url, payload, headers = {})
    json_headers headers
    res = post(url, payload, headers)
    JSON.parse res
  end

  # get and return json
  def self.json_get(url, headers = {})
    res = get(url, headers)
    JSON.parse res
  end

  # put json and return json
  def self.json_put(url, payload, headers = {})
    json_headers headers
    res = put(url, payload, headers)
    JSON.parse res
  end

  private

  def self.json_headers(headers)
    headers['Content-Type'] = 'application/json'
  end
end