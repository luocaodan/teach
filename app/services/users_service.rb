class UsersService < BaseService
  def all(params = {})
    get_with_headers 'users', params
  end
end