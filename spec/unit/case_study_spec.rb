require 'case_study'
require 'spec_helper'

describe CaseStudy do
  describe '.database_config' do
    it 'should load the config from the database' do
      expect(YAML).to receive(:load_file).with(File.expand_path('../../../config/database.yml', __FILE__))
                                         .and_return(double(fetch: {}))
      expect(CaseStudy.database_config).to eq({})
    end
  end

  describe '.database_connection' do
    let(:config) do
      {'database' => 'test'}
    end

    before do
      allow(CaseStudy).to receive(:database_config).and_return(config)
    end

    it 'should create a connection to the database' do
      expect(Sequel).to receive(:postgres).with('test')
      CaseStudy.database_connection
    end
  end

  describe '.environment' do
    it 'should return the current RACK_ENV' do
      expect(CaseStudy.environment).to eq('test')
    end

    context 'when RACK_ENV is empty' do
      before do
        ENV['RACK_ENV'] = nil
      end

      it 'should return "development"' do
        expect(CaseStudy.environment).to eq('development')
      end

      it 'should set RACK_ENV to "development"' do
        CaseStudy.environment
        expect(ENV['RACK_ENV']).to eq('development')
      end
    end
  end
end
