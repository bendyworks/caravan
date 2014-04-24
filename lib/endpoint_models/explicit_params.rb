module EndpointModels
  # Module for EndpointModel classes to extend
  module ExplicitParams
    class MissingParameterError < Exception ; end

    def allow_params(*args)
      options = args.last.is_a?(Hash) ? args.pop : Hash.new

      create_parameters allowed_parameters, proc { options[:default] }, *args
    end

    def require_params(*args)
      create_parameters(required_parameters, method(:raise_missing_paramter),
                        *args)
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

    def create_parameters(param_list, default_callable, *attrs)
      attrs.each do |attr|
        attr_reader attr
        param_list << attr
        parameter_defaults[attr] = default_callable
      end
    end

    def raise_missing_paramter(attribute, parameters)
      raise MissingParameterError,
        "#{attribute} is required but not was provided in #{parameters}"
    end

    # Class methods that are needed for every Endpoint Model class
    module ClassMethods
      def data_for(params)
        new(params).data
      end
    end

    # Methods that are needed for each instance of a class extending
    # ExplicitParams
    module InstanceMethods
      def initialize(params={})
        init_params params
      end

    private

      class UnusedParameterError < Exception ; end

      def init_params(params)
        set_attributes params
        provided_params = params.keys.map(&:to_sym)

        unused_parameters = provided_params - defined_parameters
        if unused_parameters.any?
          raise UnusedParameterError,
            'The following were provided but not used: ' +
            unused_parameters.map(&:to_s).join(',')
        end
      end

      def set_attributes(params)
        self.class.defined_parameters.each do |attribute, value|
          value = params[attribute]
          if value.nil?
            default_callable = parameter_defaults[attribute]
            value = default_callable.call(attribute, params)
          end
          instance_variable_set(:"@#{attribute}", value)
        end
      end

      def defined_parameters
        self.class.defined_parameters
      end

      def parameter_defaults
        self.class.parameter_defaults
      end

      def self.included(klass)
        klass.extend ClassMethods
      end
    end
  end
end
