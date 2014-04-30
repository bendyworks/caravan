require 'sinatra/base'

require 'apps/helpers'

module Apps
  class CaravanBase < Sinatra::Base
    include AppHelpers

    before do
      content_type 'application/json; charset=utf-8'
    end
  end
end
