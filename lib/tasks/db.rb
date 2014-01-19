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
    require 'sequel'

    # Use the migration extension
    Sequel.extension :migration

    DB = Sequel.postgres database_config['database']
    Sequel::Migrator.run(DB, 'db/migrate/')
  end

  desc "Drop the database"
  task :drop do
    require 'sequel'

    puts "Deleting the database"
    postgres = Sequel.postgres 'postgres'
    postgres.run "DROP DATABASE #{database_config['database']}"
  end

  desc "Create the skeleton for a new migration"
  task :new_migration, :migration_name do |task, args|
    latest_migration = Dir["db/migrate/*.rb"].last || "db/migrate/0000_not_a_real_migration.rb"
    index = latest_migration.match(/([0-9]+)_.*\.rb$/)  # Find the last index number
                            .captures  # Get the list which should only have one member
                            .first  # Get the first element
                            .to_i  # convert to an integer
                            .succ  # increment it by one
                            .to_s  # convert it back to a string
                            .rjust(4, '0')  # Pad it on the left with 0's, e.g., 0001
    migration_name = args[:migration_name].to_s
    new_migration = "db/migrate/#{index}_#{migration_name}.rb"
    File.open(new_migration, "w+") do |f|
      f.write <<-END_MIGRATION
Sequel.migration do
  up do
  end

  down do
  end
end
END_MIGRATION
    end

    puts "Your new migration can be found at `#{new_migration}'"
  end
end
