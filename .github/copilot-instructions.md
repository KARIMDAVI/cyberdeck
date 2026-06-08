# PROJECT-SPECIFIC COPILOT STANDARDS
# ====================================

## Project Name
**My Amazing Project** - [Brief description, e.g., "E-commerce platform with React + Node.js + PostgreSQL"]

## Project Structure
- Frontend: `/src/frontend` (React + TypeScript)
- Backend: `/src/backend` (Node.js + Express)
- Database: `/db` (PostgreSQL migrations)
- Tests: `/tests` and `**/*.test.ts` files
- Config: `/config` directory (environment configs)

## Critical Standards for THIS Project
1. **No console.log in production** (use logger)
2. **All API endpoints MUST have tests**
3. **Database migrations require approval before deploy**
4. **Security: Always validate user input**

## Project-Specific Dependencies
- React 18.x (frontend)
- Express 4.x (backend)
- PostgreSQL 14+ (database)
- Jest for testing
- ESLint + Prettier for formatting

## Team Guidelines
- PR requires 2 approvals + tests passing
- All PRs must have type: feat|fix|chore|docs
- Weekly sync: Thursday 2 PM

---

[THEN: Keep existing Phase 1 standards below — add your global content here if available]
