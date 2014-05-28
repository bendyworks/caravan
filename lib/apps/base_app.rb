require 'sinatra/base'

require 'apps/helpers'
require 'endpoint_models/errors'

module Apps
  class CaravanBase < Sinatra::Base
    set :raise_errors, true
    set :show_exceptions, false

    include AppHelpers

    before do
      content_type 'application/json; charset=utf-8'
    end
  end
end
