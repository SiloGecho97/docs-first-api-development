
module OpenApiSchema
  class ResponseValidatorMiddleware
    # Initializes the middleware with the given Rack application and sets up the response validator.
    #
    # @param app [Object] The Rack application.
    def initialize(app)
      @app = app
      @response_validator = Committee::Middleware::ResponseValidation.new(app, schema_path: "docs/openapi.json", strict_reference_validation: true)
    end

    # Sets up the middleware to validate the response schema if the "VALIDATE_SCHEMA" header is present.
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
    def condition_for_response_validation?(env)
      env.key?("HTTP_VALIDATE_SCHEMA")
    end
  end
end
