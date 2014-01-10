namespace :db do
  desc "Create a new database"
  task :create do
    require 'sequel'

    # To create a new database, we need to use the `postgres` database
    postgres = Sequel.postgres 'postgres'
    postgres.run 'CREATE DATABASE sinatra'
  end

  desc "Run the migrations on the database"
  task :migrate do
    puts "lol that's not done yet"
  end

  desc "Drop the database"
  task :drop do
    require 'sequel'

    postgres = Sequel.postgres 'postgres'
    postgres.run 'DROP DATABASE sinatra'
  end
end
