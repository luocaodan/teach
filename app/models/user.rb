class User
  attr_reader :id, :token
  def initialize(user_id, user_token)
    @id = user_id
    @token = user_token
  end
end