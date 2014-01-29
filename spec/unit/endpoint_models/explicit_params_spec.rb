require 'endpoint_models/explicit_params'

module EndpointModels
  describe ExplicitParams do
    describe 'allow_params' do
      class TestAllowedParams
        extend ExplicitParams

        allow_params :test_param
      end

      let(:test_class) { TestAllowedParams }

      it 'allows but does not require parameters' do
        expect { test_class.new }.not_to raise_error
      end

      it 'creates an attribute on the class' do
        expect { test_class.new.test_param }.not_to raise_error
      end

      it 'accepts a hash with the parameter as a key' do
        expect { test_class.new({test_param: 'test'}) }.not_to raise_error
      end

      it 'saves the name of the attribute' do
        expect(test_class.allowed_parameters).to include(:test_param)
      end

      it 'sets the attribute with the passed in parameter' do
        expect(test_class.new({test_param: 'test'}).test_param).to eq('test')
      end

      context 'when a default is provided' do
        class TestAllowedParamsWithDefaults
          extend ExplicitParams

          allow_params :test_param, default: true
        end

        let(:test_class) { TestAllowedParamsWithDefaults }

        it 'returns the default if no parameter is specified' do
          expect(test_class.new.test_param).to be true
        end
      end
    end

    describe 'require_params' do
      class TestRequiredParams
        extend ExplicitParams

        require_params :test_param
      end

      let (:test_class) { TestRequiredParams }

      it 'raises an error when no parameter is provided' do
        expect { test_class.new }.to raise_error
      end
    end
  end
end
