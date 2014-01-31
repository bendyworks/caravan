require 'bundler'
Bundler.setup

ENV['RACK_ENV'] ||= 'development'

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

require 'caravan'

DB ||= Caravan.database_connection
