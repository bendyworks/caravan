require 'spec_helper'

require 'sequel'

mock_sequel_conn = nil

Rspec.configure do |config|
  config.before(:suite) do
    mock_sequel_conn = Sequel.mock(host: db)
    Sequel::Model.db = mock_sequel_conn
  end
end
