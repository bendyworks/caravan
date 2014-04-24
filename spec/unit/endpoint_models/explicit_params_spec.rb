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

      let(:test_class) { TestRequiredParams }
      let(:error) { EndpointModels::ExplicitParams::MissingParameterError }

      it 'raises an error when no parameter is provided' do
        expect { test_class.new }.to raise_error(error)
      end

      it 'does not raise an error when no parameter is provided' do
        expect { test_class.new(test_param: 'test') }.not_to raise_error
      end

      it 'sets the value of the required parameter' do
        expect(test_class.new(test_param: 'test').test_param).to eq('test')
      end
    end

    context 'when passing undeclared parameters' do
      class TestUnusedParams
        extend ExplicitParams
      end

      it 'raises an error to warn that they were not declared' do
        expect { TestUnusedParams.new(test_param: 'test') }.to raise_error
      end
    end

    context 'when creating an Endpoint Model' do
      class TestIncludedMethods
        extend ExplicitParams

        allow_params :id

        def data; end
      end

      describe 'initialize' do
        subject { TestIncludedMethods.new(id: 1) }

        it 'accepts parameters' do
          expect { subject }.not_to raise_error
        end

        it 'parses the parameters into attributes' do
          expect(subject.id).to eq(1)
        end
      end

      describe 'data_for' do
        subject { TestIncludedMethods.data_for(id: 1) }

        it 'accepts parameters' do
          expect { subject }.not_to raise_error
        end
      end
    end
  end
end
