require 'apps/base_app'

require 'endpoint_models/users/user'

module Apps
  class Users < CaravanBase
    get '/:username' do
      respond_with EndpointModels::User.data_for(params)
    end
  end
end
