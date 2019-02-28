class User
  attr_reader :id, :token, :username
  attr_accessor :name, :avatar_url, :web_url
  def initialize(user_id, user_token, username)
    @id = user_id
    @token = user_token
    @username = username
  end
end