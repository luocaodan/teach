class UsersService < BaseService
  def all
    get 'users'
  end
end