require File.expand_path('../../caravan', __FILE__)

def migrations_dir
  File.expand_path('../../../db/migrate/', __FILE__)
end

namespace :db do
  desc 'A task for doing everything to set up this project'
  task :bootstrap => [:create, :migrate]

  desc "Provide access to the database via the Sequel gem"
  task :console do
    require 'pry'

    DB = Caravan.database_connection
    binding.pry
  end

  desc "Create a new database"
  task :create do
    require 'sequel'

    puts "Creating the database"
    postgres = Sequel.postgres 'postgres'
    postgres.run "CREATE DATABASE #{Caravan.database_config['database']}"
  end

  desc "Run the migrations on the database"
  task :migrate do
    # Use the migration extension
    Sequel.extension :migration

    DB = Caravan.database_connection

    puts "Migrating the database"
    Sequel::Migrator.run(DB, migrations_dir)
  end

  desc "Drop the database"
  task :drop do
    require 'sequel'

    puts "Deleting the database"
    postgres = Sequel.postgres 'postgres'
    postgres.run "DROP DATABASE #{Caravan.database_config['database']}"
  end

  desc "Create the skeleton for a new migration"
  task :new_migration, :migration_name do |task, args|
    index = Time.now.to_i

    if args[:migration_name].nil?
      raise "Must specify name for migration"
    end

    migration_name = args[:migration_name].to_s

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
