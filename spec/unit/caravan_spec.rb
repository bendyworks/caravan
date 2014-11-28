require 'caravan'
require 'spec_helper'

describe Caravan do
  describe '.database_config' do
    it 'should load the config from the database' do
      path = File.expand_path('../../../config/database.yml', __FILE__)
      expect(File).to receive(:read).with(path).and_return('')
      expect(YAML).to receive(:load).with('')
                                    .and_return(double(fetch: {}))
      expect(Caravan.database_config).to eq({})
    end
  end

  describe '.database_connection' do
    it 'should create a connection to the database' do
      expect(Caravan::Database).to receive(:connection)
      Caravan.database_connection
    end
  end

  describe '.environment' do
    it 'should return the current RACK_ENV' do
      expect(Caravan.environment).to eq('test')
    end

    context 'when RACK_ENV is empty' do
      before do
        ENV['RACK_ENV'] = nil
      end

      it 'should return "development"' do
        expect(Caravan.environment).to eq('development')
      end

      it 'should set RACK_ENV to "development"' do
        Caravan.environment
        expect(ENV['RACK_ENV']).to eq('development')
      end
    end
  end

  describe Caravan::Database do
    subject { Caravan::Database }

    describe 'adapter' do
      context 'when heroku bashes adapter into "postgresql"' do
        let(:heroku_config) { { 'adapter' => 'postgresql' } }

        around do |blk|
          old_config = subject.instance_variable_get('@config')
          subject.instance_variable_set('@config', heroku_config)
          blk.call
          subject.instance_variable_set('@config', @old_config)
        end

        it 'returns "postgres" instead' do
          expect(subject.send :adapter).to eq('postgres')
        end
      end
    end
  end
end
