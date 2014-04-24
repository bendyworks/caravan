require 'sinatra/base'

module Apps
  class Users < Sinatra::Base
    get '/:username' do
      halt 500
    end
  end
end
