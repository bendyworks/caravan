require 'apps/base_app'

require 'endpoint_models/users/user'

module Apps
  class Users < CaravanBase
    user_versions = {
      '1.0' => EndpointModels::UserV10,
      '2.0' => EndpointModels::User
    }

    get '/:username' do
      endpoint = user_versions.fetch(get_preferred_version('2.0', '1.0'))
      respond_with endpoint.data_for(params)
    end
  end
end
