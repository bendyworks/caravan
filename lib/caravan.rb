# Require as few dependencies here as possible. This will likely be required
# elsewhere and may not need all of the dependencies required for the rest of
# the app
require 'sequel'
require 'yaml'


# Module to encapsulate some logic about the app
module Caravan
  def self.database_config
    Database.config
  end

  def self.database_connection
    Database.connection
  end

  def self.environment
    Database.environment
  end

private

  class Database
    class << self
      def config
        path = File.expand_path("../../config/database.yml", __FILE__)
        @config ||= load_config(path).fetch(environment)
      end

      def connection
        @connection ||= Sequel.connect(connection_params)
      end

      def environment
        ENV["RACK_ENV"] ||= "development"
      end

    private

      def connection_params
        {
          adapter: adapter,
          host: config.fetch('host', ENV['DATABASE_URL']),
          port: config['port'],
          database:  config['database'],
          username: config['username'],
          password: config['password']
        }
      end

      def load_config(path)
        if environment == 'production'
          require 'erb'
          config = ERB.new(File.read(path)).result
        else
          config = File.read(path)
        end
        YAML.load(config)
      end

      def adapter
        if config['adapter'] == 'postgresql'
          'postgres'
        else
          config['adapter']
        end
      end
    end
  end
end
