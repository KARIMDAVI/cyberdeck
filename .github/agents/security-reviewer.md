## Security Reviewer Agent (Project)

## Allowed Capabilities - ENHANCED FOR THIS PROJECT

### Additional Checks
- Check for hardcoded API keys (project-specific pattern)
- Scan for database credential exposure
- Validate JWT secret configuration
- Check environment variable requirements

### Restricted Operations (STRICTER)
- NO modification of security configs
- NO disabling of security hooks
- Require approval for any config changes
