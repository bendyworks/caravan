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
end
