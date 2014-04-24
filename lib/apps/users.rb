require 'sinatra/base'

require 'endpoint_models/users/user'

module Apps
  class Users < Sinatra::Base
    get '/:username' do
      respond_with EndpointModels::User.data_for(params)
    end
  end
end
