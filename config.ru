#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

unless ENV.has_key? 'RACK_ENV'
  ENV['RACK_ENV'] = 'development'
end

# Add /lib/ to our load path
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

require 'apps/caravan'

run Apps::Caravan.new
