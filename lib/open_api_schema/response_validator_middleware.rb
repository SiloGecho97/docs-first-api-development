
module OpenApiSchema
  class ResponseValidatorMiddleware
    def initialize(app)
      @app = app
      @response_validator = Committee::Middleware::ResponseValidation.new(app, schema_path: "docs/openapi.json", strict_reference_validation: true)
    end

    # Handles the middleware call to validate the schema if the "Validate-Schema" header is present.
    # If the header is set to "1", it validates the request and response schema.
    # Otherwise, it continues the request-response cycle as usual.
    #
    # @param env [Hash] The Rack environment hash.
    # @return [Array] The status, headers, and body of the response.
    def call(env)
      status, headers, response = @app.call(env)

      if condition_for_response_validation?(env)
        status, headers, response = @response_validator.call(env)
      end

      [ status, headers, response ]
    end

    private

    def condition_for_response_validation?(env)
      env.key?("HTTP_VALIDATE_SCHEMA")
    end
  end
end
