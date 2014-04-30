require 'caravan'

Caravan.database_connection

require 'apps/users'
require 'rack/builder'

module Apps
  # The master application which maps each sub-application to its root
  # For example, Apps::Users is mount under /users
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
