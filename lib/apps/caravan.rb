require 'apps/users'

require 'rack/builder'

module Apps
  class Caravan
    def self.new
      app = Rack::Builder.app do
        map('/users') { run Apps::Users }
      end

      Rack::Builder.new do
        run app
      end
    end
  end
end
