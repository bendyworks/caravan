require 'yaml'

def environment
  ENV["RACK_ENV"] || "development"
end

def database_config
  YAML.load_file("config/database.yml").fetch(environment)
end

namespace :db do
  desc "Create a new database"
  task :create do
    require 'sequel'

    puts "Creating the database"
    postgres = Sequel.postgres 'postgres'
    postgres.run "CREATE DATABASE #{database_config['database']}"
  end

  desc "Run the migrations on the database"
  task :migrate do
    puts "lol that's not done yet"
  end

  desc "Drop the database"
  task :drop do
    require 'sequel'

    puts "Deleting the database"
    postgres = Sequel.postgres 'postgres'
    postgres.run "DROP DATABASE #{database_config['database']}"
  end
end
