require 'case_study'
require 'spec_helper'

describe CaseStudy do
  describe '.database_config' do
    it 'should load the config from the database' do
      expect(YAML).to receive(:load_file).with('config/database.yml')
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
end
