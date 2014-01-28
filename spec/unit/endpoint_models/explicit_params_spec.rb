require 'endpoint_models/explicit_params'

module EndpointModels
  describe ExplicitParams do
    describe 'allow_params' do
      before do
        class TestClass
          extend ExplicitParams

          allow_params :test_param
        end
      end

      it 'allows but does not require parameters' do
        expect { TestClass.new }.not_to raise_error
      end

      it 'creates an attribute on the class' do
        expect { TestClass.new.test_param }.not_to raise_error
      end

      it 'accepts a hash with the parameter as a key' do
        expect { TestClass.new({test_param: 'test'}) }.not_to raise_error
      end

      it 'saves the name of the attribute' do
        expect(TestClass.allowed_parameters).to include(:test_param)
      end

      context 'when a default is provided' do
        before do
          class TestCase
            extend ExplicitParams

            allow_params :test_param, default: true
          end
        end

        it 'returns the default if no parameter is specified' do
          expect(TestClass.new.test_param).to be_true
        end
      end
    end
  end
end
