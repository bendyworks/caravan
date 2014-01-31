# Require as few dependencies here as possible. This will likely be required
# elsewhere and may not need all of the dependencies required for the rest of
# the app
require 'sequel'
require 'yaml'


# Module to encapsulate some logic about the app
module Caravan
  def self.database_config
    path = File.expand_path("../../config/database.yml", __FILE__)
    YAML.load_file(path).fetch(environment)
  end

  def self.database_connection
    @connection ||= Sequel.connect(
      adapter: database_config['adapter'],
      host: database_config.fetch('host', ENV['DATABASE_URL']),
      database:  database_config['database']
    )
  end

  def self.environment
    ENV["RACK_ENV"] ||= "development"
  end
end
