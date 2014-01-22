require 'sinatra/base'

module Apps
  class UsersApp < Sinatra::Base
    get '/:username' do
      halt 500
    end
  end
end
