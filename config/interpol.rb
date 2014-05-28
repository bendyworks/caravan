require 'interpol'

Interpol.default_configuration do |config|
  # Tells Interpol where to find your endpoint definition files.
  config.endpoint_definition_files = Dir["lib/endpoint_definitions/**/*.yml"]

  # Determines which versioned response endpoint definition Interpol uses
  # for a request. You can also use a block form, which yields
  # the rack env hash and the endpoint object as arguments.
  # This is useful when you need to extract the version from a
  # request header (e.g. Accept) or from the request URI.
  #
  # Needed by Interpol::StubApp and Interpol::ResponseSchemaValidator.
  config.response_version do |env, endpoints|
    if env['HTTP_ACCEPT'].to_s =~ /.*v=(\d+\.\d+)/
      $1
    else
      endpoints.available_response_versions.max
    end
  end

  # Determines which versioned request endpoint definition Interpol uses
  # for a request. You can also use a block form, which yields
  # the rack env hash and the endpoint object as arguments.
  # This is useful when you need to extract the version from a
  # request header (e.g. Content-Type) or from the request URI.
  #
  # Needed by Interpol::Sinatra::RequestParamsParser.
  config.request_version do |env, endpoints|
    if env['HTTP_ACCEPT'].to_s =~ /.*v=(\d+\.\d+)/
      $1
    else
      endpoints.available_request_versions.max
    end
  end

  # Determines the stub app response when the requested version is not
  # available. This block will be eval'd in the context of a
  # sinatra application, so you can use sinatra helpers like `halt` here.
  #
  # Used by Interpol::StubApp and Interpol::Sinatra::RequestParamsParser.
  config.on_unavailable_sinatra_request_version do |requested_version, available_versions|
    message = JSON.dump(
      "message" => "Not Acceptable",
      "requested_version" => requested_version,
      "available_versions" => available_versions
    )

    halt 406, message
  end

  # Determines the response when the requested version is not available.
  #
  # Used by Interpol::RequestBodyValidator.
  config.on_unavailable_request_version do |env, requested_version, available_versions|
    [406, { 'Content-Type' => 'text/plain' }, ['Wrong Version!']]
  end

  # Determines which responses will be validated against the endpoint
  # definition when you use Interpol::ResponseSchemaValidator. The
  # validation is meant to run against the "happy path" response.
  # For responses like "404 Not Found", you probably don't want any
  # validation performed. The default validate_response_if hook will cause
  # validation to run against any 2xx response except 204 ("No Content").
  #
  # Used by Interpol::ResponseSchemaValidator.
  config.validate_response_if do |env, status, headers, body|
    # Only validate for 2xx responses that aren't 204s
    (200..299).include?(status) && status != 204 &&
      headers['Content-Type'] =~ %r|application/json|
  end

  # Determines which request bodies to validate.
  #
  # Used by Interpol::RequestBodyValidator.
  config.validate_request_if do |env|
    env['CONTENT_TYPE'].to_s.include?('json') &&
    %w[ POST PUT ].include?(env.fetch('REQUEST_METHOD'))
  end

  # Determines how Interpol::ResponseSchemaValidator handles
  # invalid data. By default it will raise an error, but you can
  # make it print a warning instead.
  #
  # Used by Interpol::ResponseSchemaValidator.
  config.validation_mode = :error # or :warn

  # Determines the title shown on the rendered documentation
  # pages.
  #
  # Used by Interpol::DocumentationApp.
  config.documentation_title = "Caravan API Documentaton"

  # Sets a callback that can be used to filter example data.
  # This is useful when you want your stub app to serve data
  # that is a bit dynamic. You can set multiple of these, and
  # each will be called in declared order.
  #
  # Used by Interpol::StubApp, Interpol::TestHelper::RSpec and
  # Interpol::TestHelper::TestUnit.
  config.filter_example_data do |example, request_env|
    example.data["current_url"] = Rack::Request.new(request_env).url
  end

  # Sets a callback that will be used to determine which example
  # to return from the stub app. If you provide an endpoint name,
  # the block will apply only to requests to that endpoint.
  # If no name is provided, the block will set the default selector
  # logic. By default, if this config is not set, interpol will use
  # the first example.
  #
  # Used by Interpol::StubApp.
  config.select_example_response('some-endpoint') do |endpoint_def, request_env|
    endpoint_def.examples[3]
  end
  config.select_example_response do |endpoint_def, request_env|
    endpoint_def.examples.first
  end

  # Determines what to do when Interpol::Sinatra::RequestParamsParser
  # detects invalid path or query parameters based on their schema
  # definitions. This block will be eval'd in the context of your
  # sinatra application so you can use any helper methods such as
  # `halt`.
  #
  # Used by Interpol::Sinatra::RequestParamsParser.
  config.on_invalid_sinatra_request_params do |error|
    halt 400, JSON.dump(:error => error.message)
  end

  # Determines how to respond when the request body is invalid
  # based on your schema definition.
  #
  # Used by Interpol::RequestBodyValidator.
  config.on_invalid_request_body do |env, error|
    [400, { 'Content-Type' => 'text/plain' }, [error.message]]
  end
end
