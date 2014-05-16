require 'caravan'

Caravan.database_connection

require File.expand_path("../../../config/interpol", __FILE__)

require 'apps/users'
require 'rack/builder'
require 'interpol/request_body_validator'
require 'interpol/response_schema_validator'
require 'interpol/sinatra/request_params_parser'

module Apps
  # The master application which maps each sub-application to its root
  # For example, Apps::Users is mount under /users
  class Caravan
    def self.new
      app = Rack::Builder.new do
        use Interpol::RequestBodyValidator
        use Interpol::ResponseSchemaValidator

        map('/users') { run Apps::Users.new }
      end

      Rack::Builder.app do
        run app
      end
    end
  end
end
