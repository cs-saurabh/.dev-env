# Skill: Deployment Patterns

## PURPOSE
Guide the infrastructure agent through deployment scripts, environment configuration, and release management.

## ENVIRONMENT MANAGEMENT

### Environment Hierarchy
```
development  -> local machine, docker-compose, hot reload
staging      -> mirrors production, test with real-ish data
production   -> live, monitored, scaled
```

### Configuration Strategy
- **Environment variables** for all environment-specific config
- **`.env.example`** checked into git with placeholder values and comments
- **Never commit** `.env` files with real values
- **Validate at startup** -- fail fast if required env vars are missing

```typescript
// config.ts -- validate required env vars at startup
const requiredVars = ['DATABASE_URL', 'JWT_SECRET', 'API_KEY'];
for (const v of requiredVars) {
  if (!process.env[v]) throw new Error(`Missing required env var: ${v}`);
}
```

## DEPLOYMENT SCRIPTS

### Pre-Deployment Checklist Script
```bash
#!/bin/bash
set -e
echo "Pre-deployment checklist..."
npm run lint || { echo "Lint failed"; exit 1; }
npm run test || { echo "Tests failed"; exit 1; }
npm run build || { echo "Build failed"; exit 1; }
echo "All checks passed. Ready to deploy."
```

### Database Migration Script
```bash
#!/bin/bash
set -e
echo "Running database migrations..."
npm run migration:run
echo "Migrations complete. Verifying..."
npm run migration:status
```

## DEPLOYMENT STRATEGIES

### Rolling Deployment
- Deploy new version gradually, replacing old instances one at a time
- Zero downtime if health checks are configured
- Easy rollback -- just redeploy the previous version

### Blue-Green Deployment
- Run two identical environments (blue = current, green = new)
- Deploy to green, test, then switch traffic
- Instant rollback by switching back to blue

## ROLLBACK PROCEDURES

Always have a rollback plan:
1. **Code rollback**: Redeploy the previous version (tag/commit)
2. **Database rollback**: Have down migrations ready (don't deploy irreversible schema changes without a plan)
3. **Configuration rollback**: Keep previous env var values accessible
4. **Verification**: After rollback, run smoke tests to confirm system is stable

## HEALTH CHECKS

Every service should expose:
```
GET /health -> 200 OK { status: "ok", version: "1.2.3", uptime: 12345 }
GET /ready  -> 200 OK (only when service is ready to handle traffic)
```

- `/health` -- is the process alive?
- `/ready` -- is the process able to serve requests? (DB connected, cache warm, etc.)
