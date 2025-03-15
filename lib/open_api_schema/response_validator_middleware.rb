
# Common options for both request and response validation
# common_options = {
#   schema_path: Rails.root.join("docs", "schema.json").to_s,
#   error_handler: error_handler,
#   strict: true, # Enforce strict validation
#   coerce_date_times: true, # Automatically coerce date-time strings to DateTime objects
#   coerce_path_params: true, # Coerce path parameters to expected types
#   coerce_query_params: true, # Coerce query parameters to expected types
#   coerce_form_params: true, # Coerce form parameters to expected types
#   allow_blank: true, # Allow blank values in parameters
#   allow_form_params: true, # Allow form parameters in requests
#   allow_query_params: true, # Allow query parameters in requests
#   check_content_type: true, # Validate the Content-Type header
#   check_header: true, # Validate headers according to schema
#   optimistic_json: true, # Parse JSON in an optimistic manner
#   parse_response_by_content_type: true, # Parse response based on Content-Type
#   validate_success_only: true, # Validate only successful responses (2xx status codes)
#   query_hash_key: "action_dispatch.request.query_parameters", # Key for query parameters in the environment
#   form_hash_key: "action_dispatch.request.request_parameters", # Key for form parameters in the environment
#   headers_key: "action_dispatch.request.headers", # Key for headers in the environment
#   raise: false, # Do not raise exceptions on validation errors
#   ignore_error: true # Continue processing even if validation fails
# }


module OpenApiSchema
  class ResponseValidatorMiddleware
    # Initializes the middleware with the given Rack application and sets up the response validator.
    #
    # @param app [Object] The Rack application.
    def initialize(app)
      @app = app
       # Handles the middleware call to validate the schema if the "VALIDATE_SCHEMA" header is present.
       error_handler = Proc.new do |error, env|
        logger = Logger.new(Rails.root.join("log", "committee_validation.log"))
        logger.error("Committee Validation Error: #{error.message}")
      end

      @response_validator = Committee::Middleware::ResponseValidation.new(app, schema_path: "docs/openapi.json",  ignore_error: true, error_handler: error_handler)
    end

    #
    # @param env [Hash] The Rack environment hash.
    # @return [Array] The status, headers, and response.
    def call(env)
      status, headers, response = @app.call(env)

      if condition_for_response_validation?(env)
        status, headers, response = validate_response(env, status, headers, response)
      end

      [ status, headers, response ]
    end

    private




    # Checks if the "Validate-Schema" header is present in the environment hash.
    #
    # @param env [Hash] The Rack environment hash.
    # @return [Boolean] True if the "Validate-Schema" header is present, false otherwise.
    def condition_for_response_validation?(env)
     true # env.key?("HTTP_VALIDATE_SCHEMA")
    end

    def validate_response(env, status, headers, response)
      begin
        @response_validator.call(env)
      rescue StandardError => e
        @logger.error("Response Validation Failed: #{e.message}") # Log the error, TODO: add more information
        [ status, headers, response ] # Return original response even if validation fails
      end
    end
  end
end
