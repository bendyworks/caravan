require 'case_study'
require 'spec_helper'

describe Caravan do
  describe '.database_config' do
    it 'should load the config from the database' do
      path = File.expand_path('../../../config/database.yml', __FILE__)
      expect(YAML).to receive(:load_file).with(path)
                                         .and_return(double(fetch: {}))
      expect(Caravan.database_config).to eq({})
    end
  end

  describe '.database_connection' do
    let(:config) do
      {'database' => 'test'}
    end

    before do
      allow(Caravan).to receive(:database_config).and_return(config)
    end

    it 'should create a connection to the database' do
      expect(Sequel).to receive(:postgres).with('test')
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
end
