module EndpointModels
  # Module for EndpointModel classes to extend
  module ExplicitParams
    def allow_params(*args)
      args.each do |name|
        attr_reader name
      end
    end

    def require_params(*args) ; end

    def allowed_parameters
      @allowed_parameters ||= []
    end

    def required_parameters
      @required_parameters ||= []
    end

  private

    def self.extended(klass)
      klass.class_eval do
        # When a class extends a module, you cannot add instance methods.
        # Instead you have to do a bit more work to include some instance
        # methods common to each class.
        include InstanceMethods
      end
    end

    # Methods that are needed for each instance of a class extending
    # ExplicitParams
    module InstanceMethods
      def initialize(params={})
        params.each do |attr, value|
          instance_variable_set(:"@#{attr}", value)
        end
      end
    end
  end
end
