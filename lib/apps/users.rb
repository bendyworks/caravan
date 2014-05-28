require 'apps/base_app'

require 'endpoint_models/users/user'
require 'endpoint_models/users/user_by_id'

module Apps
  class Users < CaravanBase
    user_versions = {
      '1.0' => EndpointModels::UserV10,
      '2.0' => EndpointModels::User
    }

    # RestClient.get 'https://server.com/users/ceaess'
    get '/:username' do
      endpoint = user_versions.fetch(get_preferred_version('2.0', '1.0'))
      respond_with endpoint.data_for(params)
    end

    get '/by-id/:id' do
      respond_with EndpointModels::UserById.data_for(params)
    end
  end
end
