require 'sinatra/base'

require 'apps/helpers'
require 'endpoint_models/users/user'

module Apps
  class Users < Sinatra::Base
    include AppHelpers

    get '/:username' do
      respond_with EndpointModels::User.data_for(params)
    end
  end
end
