# Require as few dependencies here as possible. This will likely be required
# elsewhere and may not need all of the dependencies required for the rest of
# the app
require 'sequel'
require 'yaml'


module CaseStudy
  def self.database_config
    YAML.load_file("config/database.yml").fetch(environment)
  end

  def self.database_connection
    @connection ||= Sequel.postgres database_config['database']
  end

  def self.environment
    ENV["RACK_ENV"] ||= "development"
  end
end
