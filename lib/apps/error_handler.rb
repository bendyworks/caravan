require 'endpoint_models/errors'

module Apps
  module Middleware
    class ErrorHandler
      def initialize(app)
        @app = app
      end

      def call(env)
        begin
          @app.call(env)
        rescue NotFoundError
          not_found_error
        end
      end

      private

      def not_found_error
        [404, { "Content-Type" => "application/json" }, []]
      end
    end
  end
end
