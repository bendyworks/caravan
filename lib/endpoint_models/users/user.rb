require 'endpoint_models/explicit_params'
require 'models/users'

module EndpointModels
  # Endpoint to retrieve information about a username
  class User
    extend ExplicitParams

    require_params :username

    def data
      user
    end

  private

    def user
      u = ::Users.find(login: username)
      raise NotFoundError unless u
      u.values
    end
  end

  # Version 1.0 of user endpoint to retrieve information about a username
  # It removes the User's id
  class UserV10 < User

  private

    def user
      @user = super
      @user.delete_if { |k, v| k == :id }
    end
  end
end
