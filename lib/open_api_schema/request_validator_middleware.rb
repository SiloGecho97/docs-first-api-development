
module OpenApiSchema
  class RequestValidatorMiddleware
    def initialize(app)
      @app = app
      @request_validator = Committee::Middleware::RequestValidation.new(app, schema_path: "docs/openapi.json", strict_reference_validation: true,  coerce_date_times: true,  params_key: "action_dispatch.request.request_parameters", query_hash_key: "action_dispatch.request.query_parameters")
    end

    # Handles the middleware call to validate the schema if the "VALIDATE_SCHEMA" header is present.
    # If the header is set to "1", it validates the request schema.
    # Otherwise, it continues the request-response cycle as usual.
    #
    # @param env [Hash] The Rack environment hash.
    # @return [Array] The status, headers, and response.
    def call(env)
      status, headers, response = @app.call(env)


      if condition_for_request_validation?(env)
        status, headers, response = @request_validator.call(env)
      end

      [ status, headers, response ]
    end

    private

    def condition_for_request_validation?(env)
      env.key?("HTTP_VALIDATE_SCHEMA")
    end
  end
end
