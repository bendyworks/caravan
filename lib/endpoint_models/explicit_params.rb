module EndpointModels
  # Module for EndpointModel classes to extend
  module ExplicitParams
    class MissingParameterError < Exception ; end

    def allow_params(*args)
      options = args.last.is_a?(Hash) ? args.pop : Hash.new

      args.each do |name|
        attr_reader name
        allowed_parameters << name
        parameter_defaults[name] = -> { options[:default] }
      end
    end

    def require_params(*args)
      args.each do |name|
        attr_reader name
        required_parameters << name
        parameter_defaults[name] = -> do
          raise MissingParameterError, "#{name} required but not provided."
        end
      end
    end

    def allowed_parameters
      @allowed_parameters ||= []
    end

    def required_parameters
      @required_parameters ||= []
    end

    def defined_parameters
      allowed_parameters + required_parameters
    end

    def parameter_defaults
      @parameter_defaults ||= Hash.new(-> { nil })
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
        init_params params
      end

      def self.data_for(params)
        new(params).data
      end

    private

      def init_params(params)
        params.each do |attr, value|
          set_attr(attr, value)
        end
        provided_params = params.keys

        need_defaults = self.class.defined_parameters - provided_params
        need_defaults.each do |attr|
          value = self.class.parameter_defaults[attr].call
          set_attr(attr, value)
        end
      end

      def set_attr(attr, value)
        instance_variable_set(:"@#{attr}", value)
      end
    end
  end
end
