## Documentation Agent (Project)

### Typical Workflows - CUSTOMIZED

1. API Documentation

User: "Generate API documentation"
Agent:
  1. Scan: `/src/backend/routes/*.ts`
  2. Extract: All endpoints with @doc tags
  3. Generate: README.API.md with:
     - All endpoints listed
     - Request/response examples
     - Authentication required
     - Rate limits
  4. Include: Code examples from /examples/api/
