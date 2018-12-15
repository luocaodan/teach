class User
  attr_reader :id, :token, :username
  def initialize(user_id, user_token, username)
    @id = user_id
    @token = user_token
    @username = username
  end
end