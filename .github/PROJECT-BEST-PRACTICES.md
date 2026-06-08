# Project-Specific Best Practices

## For THIS Project

### DO ✅
- Always run tests before commit: `npm test`
- Always check types before push: `npm run type-check`
- Update database migrations before code changes
- Document API changes in /docs
- Run security scan weekly: `npm audit`

### DON'T ❌
- Never hardcode API keys or secrets
- Never skip tests on production-critical branches
- Never modify database schema directly (use migrations)
- Never commit console.log() statements
- Never force-push to main/develop

### Testing Requirements
- Unit tests for all functions: Jest
- Integration tests for API endpoints: Supertest
- Coverage minimum: 80%
- Run: `npm test -- --coverage`

### Security Checklist
- [ ] No secrets in code
- [ ] All inputs validated
- [ ] SQL injection prevention (use prepared statements)
- [ ] JWT properly configured
- [ ] CORS properly configured
- [ ] Run `npm audit` monthly
