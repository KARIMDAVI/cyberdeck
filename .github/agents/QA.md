## QA Agent (Project)

### Typical Workflows - CUSTOMIZED FOR THIS PROJECT

1. Test Validation (Node.js + Jest)

User: "Run tests and report coverage"
Agent:
  1. Execute: `npm test -- --coverage --passWithNoTests`
  2. Check: coverage > 80% for /src
  3. Report: "All tests passing, 85% coverage"
  4. Alert: "Database integration tests skipped, run: npm run test:db"

2. Build Verification (Express API)

User: "Verify build succeeds"
Agent:
  1. Execute: `npm run build`
  2. Check: No TypeScript errors
  3. Report: "Build successful, 0 errors"
  4. Alert: "API endpoint count: 24"
