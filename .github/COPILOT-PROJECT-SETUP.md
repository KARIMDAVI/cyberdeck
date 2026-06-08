# Copilot Setup for This Project

## Quick Start (5 minutes)

### 1. First Time Setup
```bash
# Clone repo
git clone <your-repo>
cd <your-project>

# Install dependencies
npm install

# Verify Copilot integration
npm test  # Should pass

# You're ready!
```

### 2. Using Copilot
```bash
# Write code with Copilot guidance
copilot ask "Create a new API endpoint for user registration"

# Run tests before commit
npm test

# QA Agent validates quality
copilot ask --agent qa "Run tests and report coverage"

# Security check
copilot ask --agent security-reviewer "Scan for vulnerabilities"

# Generate docs
copilot ask --agent doc-writer "Generate API documentation"
```

### 3. Standards This Project Follows
- See: `.github/copilot-instructions.md` (global)
- Plus: `.github/PROJECT-BEST-PRACTICES.md` (project-specific)

### 4. Available Agents
- `@qa` - Run tests, validate builds
- `@security-reviewer` - Scan vulnerabilities
- `@doc-writer` - Generate documentation

### 5. Git Hooks (Automatic)
- Pre-commit: Blocks dangerous commands
- Audit: Logs all Copilot actions

## Project Structure
- `/src/frontend` - React app
- `/src/backend` - Node.js API
- `/db` - Database migrations
- `/tests` - Test files
- `/.github` - Copilot config

## Common Commands
```bash
npm test              # Run all tests
npm run build         # Build project
npm run lint          # Check code quality
npm audit             # Check dependencies
npm run type-check    # Check TypeScript
```

## Questions?
1. Check: `~/.github/TEAM-GUIDE.md` (general guide)
2. Check: `.github/PROJECT-BEST-PRACTICES.md` (this project)
3. Check: `.github/copilot-instructions.md` (standards)