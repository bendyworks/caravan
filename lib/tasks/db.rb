require File.expand_path('../../case_study', __FILE__)

def migrations_dir
  File.expand_path('../../../db/migrate/', __FILE__)
end

def latest_migration_version
  # Find the latest migration
  latest_migration = Dir["#{migrations_dir}/*.rb"].last
  # If there is none, make up a name for one
  return 0 if latest_migration.nil?

  # Get the index for the new migration
  latest_migration.match(/([0-9]+)_.*\.rb$/)  # Find the last index number
                  .captures  # Get the list which should only have one member
                  .first  # Get the first element
                  .to_i  # convert to an integer
end

namespace :db do
  desc "Provide access to the database via the Sequel gem"
  task :console do
    require 'pry'

    DB = CaseStudy.database_connection
    binding.pry
  end

  desc "Create a new database"
  task :create do
    require 'sequel'

    puts "Creating the database"
    postgres = Sequel.postgres 'postgres'
    postgres.run "CREATE DATABASE #{CaseStudy.database_config['database']}"
  end

  desc "Run the migrations on the database"
  task :migrate do
    # Use the migration extension
    Sequel.extension :migration

    DB = CaseStudy.database_connection

    puts "Migrating the database"
    Sequel::Migrator.run(DB, migrations_dir)
  end

  desc "Drop the database"
  task :drop do
    require 'sequel'

    puts "Deleting the database"
    postgres = Sequel.postgres 'postgres'
    postgres.run "DROP DATABASE #{CaseStudy.database_config['database']}"
  end

  desc "Create the skeleton for a new migration"
  task :new_migration, :migration_name do |task, args|
    index = latest_migration_version
      .succ  # increment it by one
      .to_s  # convert it back to a string
      .rjust(4, '0')  # Pad it on the left with 0's, e.g., 0001

    migration_name = (args[:migration_name] || 'unnamed_migration').to_s

    # Create the file name
    new_migration = migrations_dir + "/#{index}_#{migration_name}.rb"

    # Write the skeleton for a migration
    File.open(new_migration, "w+") do |f|
      f.write <<-END_MIGRATION
Sequel.migration do
  # If your migration is simple, you can simplify this to
  # change do
  # end

  up do
  end

  down do
  end
end
END_MIGRATION
    end

    puts "Your new migration can be found at `#{new_migration}'"
  end

  desc "Recreate the database. (db:drop, db:create, db:migrate)"
  task :recreate => [:drop, :create, :migrate]
end
