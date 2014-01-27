module EndpointModels
  # Module for EndpointModel classes to extend
  module ExplicitParams
    def allow_params(*args) ; end

    def require_params(*args) ; end

    def allowed_parameters
      @allowed_parameters ||= []
    end

    def required_parameters
      @required_parameters ||= []
    end
  end
end
