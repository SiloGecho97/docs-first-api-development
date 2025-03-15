
module OpenApiSchema
  class ResponseValidatorMiddleware
    # Initializes the middleware with the given Rack application and sets up the response validator.
    #
    # @param app [Object] The Rack application.
    def initialize(app)
      @app = app
      @response_validator = Committee::Middleware::ResponseValidation.new(app, schema_path: "docs/openapi.json", strict_reference_validation: true)
    end

    # Handles the middleware call to validate the schema if the "VALIDATE_SCHEMA" header is present.
    # If the header is set to "1", it validates the response schema.
    #
    # @param env [Hash] The Rack environment hash.
    # @return [Array] The status, headers, and response.
    def call(env)
      status, headers, response = @app.call(env)

      if condition_for_response_validation?(env)
        status, headers, response = @response_validator.call(env)
      end

      [ status, headers, response ]
    end

    private

    # Checks if the "Validate-Schema" header is present in the environment hash.
    #
    # @param env [Hash] The Rack environment hash.
    # @return [Boolean] True if the "Validate-Schema" header is present, false otherwise.
    def condition_for_response_validation?(env)
      env.key?("HTTP_VALIDATE_SCHEMA")
    end
  end
end
