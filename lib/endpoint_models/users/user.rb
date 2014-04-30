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
      @user = ::Users.find(login: username).values
      @user ||= {}
      @user.delete_if { |k, v| k == :id }
    end
  end
end
