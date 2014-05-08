require 'set'

module EndpointModels
  # Module for EndpointModel classes to extend
  module ExplicitParams
    class MissingParameterError < Exception ; end

    def allow_params(*args)
      options = args.last.is_a?(Hash) ? args.pop : Hash.new

      create_parameters(allowed_parameters, proc { options[:default] }, *args)
    end

    def require_params(*args)
      create_parameters(required_parameters, method(:raise_missing_paramter),
                        *args)
    end

    def ignore_params(*args)
      ignore_parameters(args)
    end

    def allowed_parameters
      @allowed_parameters ||= []
    end

    def required_parameters
      @required_parameters ||= []
    end

    def ignored_parameters
      @ignored_parameters ||= [:splat, :captures]
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

    def ignore_parameters(parameters)
      to_ignore = ignored_parameters - parameters
      ignored_parameters += to_ignore
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

        unused_parameters = provided_params - all_parameters
        if unused_parameters.any?
          raise UnusedParameterError,
            'The following were provided but not used: ' +
            unused_parameters.map(&:to_s).join(',')
        end
      end

      def set_attributes(params)
        defined_parameters.each do |attribute, value|
          value = params[attribute]
          if value.nil?
            default_callable = parameter_defaults[attribute]
            value = default_callable.call(attribute, params)
          end
          instance_variable_set(:"@#{attribute}", value)
        end
      end

      def defined_parameters
        @defined_parameters ||= Array(
          retrieve_from_ancestors :defined_parameters, Set.new
        )
      end

      def ignored_parameters
        @ignored_parameters ||= Array(
          retrieve_from_ancestors :ignored_parameters, Set.new
        )
      end

      def all_parameters
        defined_parameters + ignored_parameters
      end

      def parameter_defaults
        @parameter_defaults ||= retrieve_from_ancestors :parameter_defaults, {}
      end

      def retrieve_from_ancestors(method, values)
        klass = self.class

        loop do
          values = values.merge klass.public_send(method)
          klass = klass.superclass
          break unless klass.respond_to? method
        end

        values
      end

      def self.included(klass)
        klass.extend ClassMethods
      end
    end
  end
end
