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
    end
  end
end
