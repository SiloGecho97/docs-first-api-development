# Documentation first API development

### What is Documentation-First Approach and its Benefits

The documentation-first approach, also known as design-first or API-first, emphasizes creating API documentation before writing any code.The documentation itself acts as a specification.

### Benefits of Documentation-First Approach

- **Clarity and Communication**: By documenting the API first, all team members, including developers, testers, and business stakeholders, have a clear understanding of the API's purpose and functionality.
- **Early Feedback**: Documentation can be reviewed and validated by stakeholders before any code is written, allowing for early detection of potential issues or misunderstandings.
- **Consistency**: Ensures that the implementation adheres strictly to the agreed-upon design, reducing the risk of discrepancies between the documentation and the actual API.
- **Improved Collaboration**: Facilitates better collaboration between different teams (e.g., frontend and backend) as they can work from a shared, well-defined API specification.
- **Better Testing**: Test cases can be derived from the documentation, ensuring comprehensive test coverage and validation against the specified API behavior.
- **Ease of Maintenance**: Having a well-documented API makes it easier to maintain and update, as changes can be tracked and communicated effectively through the documentation.

By adopting a documentation-first approach, teams can create more reliable, understandable, and maintainable APIs, ultimately leading to better software quality and user satisfaction.

### OpenAPI Specification

The OpenAPI Specification (OAS) is a standard for defining and describing RESTful APIs. It allows both humans and computers to understand the capabilities of a service without accessing its source code or documentation.

OpenAPI uses a different specification: JSON Schema. This can be used to validate JSON even outside OpenAPI, and it’s a great tool; it’s really readable and easy to understand, but it’s a bit verbose. To fix that, we can use references:

e.g., OpenAPI schema: [Petstore Example](https://petstore3.swagger.io/#/)

### Gem Used: `committee`

We used the `committee` gem for our API documentation and validation. It helps in ensuring that our API conforms to the OpenAPI specification.

Altenative gem : [Skooma](https://github.com/skryukov/skooma), [Open-api-first](https://github.com/ahx/openapi_first)

### Non Breaking change

- Add headers to requests, only do validation if headers persent
  This is how the request validation added
- For non-breaking changes, instead of returning errors, we log the errors. This approach helps in maintaining the stability of the API while still capturing any issues that need to be addressed.
  - this is how the response validation added

### Documenation UI

Scalar is add for open api schema UI
