require 'endpoint_models/errors'
require 'endpoint_models/explicit_params'
require 'models/users'

module EndpointModels
  class UserById
    extend ExplicitParams

    require_params :id

    def data
      user_by_id
    end

  private

    def user_by_id
      raise NotFoundError if user.nil?
      user.values
    end

    def user
      @user ||= ::Users.find(id: id)
    end
  end
end
