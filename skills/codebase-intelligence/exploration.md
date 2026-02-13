# Skill: Systematic Codebase Exploration

## PURPOSE
Guide the codebase-intelligence agent through a structured exploration of any codebase -- from high-level structure down to specific implementation details.

## EXPLORATION PROTOCOL

### Level 1: Project Overview (always start here)
1. Read the project root for key files:
   - `package.json` / `requirements.txt` / `pyproject.toml` -> dependencies and scripts
   - `tsconfig.json` / `setup.cfg` -> configuration
   - `README.md` -> project purpose and setup
   - `.env.example` / `docker-compose.yml` -> infrastructure hints
2. Map the top-level directory structure
3. Identify the framework/stack from dependencies

### Level 2: Architecture Discovery
1. Find entry points:
   - React: `src/index.tsx`, `src/App.tsx`, router config
   - NestJS: `src/main.ts`, `src/app.module.ts`
   - Python: `main.py`, `app.py`, `manage.py`, `__main__.py`
2. Map the module/feature organization:
   - Feature-based? (`src/features/auth/`, `src/features/dashboard/`)
   - Layer-based? (`src/controllers/`, `src/services/`, `src/models/`)
   - Hybrid?
3. Identify shared utilities, constants, types, and configurations

### Level 3: Feature Deep Dive
1. Locate the specific feature/module requested
2. Read the main component/controller/service file
3. Trace imports to understand dependencies
4. Map the data flow: where does data come from, how is it transformed, where does it go?
5. Identify state management patterns (Redux slices, context providers, service state)

### Level 4: Cross-Service Tracing
1. Find API call sites (axios, fetch, HttpService)
2. Match frontend API calls to backend endpoints
3. Trace through middleware, guards, interceptors
4. Follow data through service layers to database queries

## EXPLORATION PATTERNS BY STACK

### React Projects
- Start from router config to understand page structure
- Identify state management: Redux store -> slices -> selectors -> components
- Map component hierarchy: pages -> layouts -> features -> shared components
- Look for hooks directories for custom business logic

### NestJS Projects
- Start from `app.module.ts` to see all imported modules
- Each module: controller -> service -> repository/provider pattern
- Check `main.ts` for global middleware, pipes, interceptors
- Look for guards (auth), DTOs (validation), entities (database schema)

### Python Projects
- Start from entry point to understand application bootstrap
- Check for web framework patterns (FastAPI routes, Django views)
- Trace data pipeline flows: input -> transform -> output
- Look for configuration management and environment handling

## ANTI-PATTERNS TO AVOID
- Don't read every file -- be strategic about what you explore
- Don't get lost in node_modules or vendor directories
- Don't read generated files (dist/, build/, .next/)
- Don't assume patterns -- verify by reading the actual code
- Don't explore more than needed for the task at hand
