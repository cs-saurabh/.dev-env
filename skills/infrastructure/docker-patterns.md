---
name: docker-patterns
agent: infrastructure
type: patterns
description: "Write production-quality Docker and docker-compose configurations"
---

# Skill: Docker Patterns

## PURPOSE
Guide the infrastructure agent to write production-quality Docker configurations.

## DOCKERFILE BEST PRACTICES

### Multi-Stage Builds
```dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine AS production
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "dist/main.js"]
```

### Key Principles
- Use specific base image tags (not `latest`)
- Use alpine variants for smaller images
- Copy package files first, install deps, THEN copy source (layer caching)
- Use `npm ci` not `npm install` for reproducible builds
- Run as non-root user (`USER node`)
- Include HEALTHCHECK
- Use `.dockerignore` to exclude `node_modules`, `.git`, test files

### .dockerignore
```
node_modules
.git
.env
*.md
tests
coverage
.github
```

## DOCKER COMPOSE

### Development Setup
```yaml
version: '3.8'
services:
  app:
    build:
      context: .
      target: builder  # use build stage for dev
    volumes:
      - .:/app
      - /app/node_modules  # exclude node_modules from bind mount
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    depends_on:
      db:
        condition: service_healthy

  db:
    image: mongo:7
    ports:
      - "27017:27017"
    volumes:
      - db_data:/data/db
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongosh --quiet
      interval: 10s
      timeout: 5s
      retries: 3

volumes:
  db_data:
```

### Environment Variables
- Never hardcode secrets in docker-compose files
- Use `.env` files for local development (gitignored)
- Use Docker secrets or external secret managers for production
- Document all required env vars in `.env.example`

## COMMON PATTERNS

### Node.js Service
- Base: `node:20-alpine`
- Multi-stage: build + production
- Health check on `/health` endpoint

### Python Service
- Base: `python:3.12-slim`
- Use `pip install --no-cache-dir` to reduce image size
- Use `requirements.txt` with pinned versions

### Frontend (React/Next.js)
- Build stage: compile and bundle
- Production stage: serve with nginx or standalone
- Static assets with proper caching headers
