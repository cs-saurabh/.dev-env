# Skill: Dependency and Flow Tracing

## PURPOSE
Trace data flow, control flow, and dependency chains across files, modules, and services. Essential for understanding how changes propagate and what a modification will affect.

## TRACING TECHNIQUES

### Import Chain Tracing
Follow the import graph from a target file:
1. Read the target file's imports
2. For each significant import, read that file's exports and imports
3. Build a dependency tree (stop at framework/library boundaries)
4. Identify circular dependencies or deep chains

### Data Flow Tracing (Frontend)
Track how data moves from source to UI:
```
API Response
  -> Service/API client (src/services/ or src/api/)
  -> Redux action/thunk (src/store/slices/)
  -> Redux state update (reducer)
  -> Selector (src/store/selectors/)
  -> Component props (via useSelector or connect)
  -> UI rendering (JSX)
```

### Data Flow Tracing (Backend)
Track how a request flows through the system:
```
HTTP Request
  -> Middleware (logging, cors, etc.)
  -> Guards (authentication, authorization)
  -> Interceptors (transform, cache, timeout)
  -> Pipes (validation, transformation)
  -> Controller method
  -> Service method (business logic)
  -> Repository/ORM (database query)
  -> Response transformation
  -> HTTP Response
```

### Data Flow Tracing (Cross-Service)
Track how data moves between services:
```
Frontend Component
  -> API call (axios/fetch)
  -> [Network]
  -> Backend Controller
  -> Service logic
  -> Database / External API / Message Queue
  -> Response path back
```

### Impact Analysis
When tracing "what does changing X affect?":
1. Find all files that import/reference the target
2. For each consumer, check if it uses the specific export being changed
3. Trace consumers' consumers (ripple effect) -- but limit depth to 3 levels
4. Categorize impact: direct (uses the changed API) vs indirect (uses something that uses it)

## OUTPUT FORMAT FOR TRACES

```
## Dependency Trace: [Target]

### Direct Dependencies (imports)
- `file.ts` imports from `dep1.ts` (uses: FunctionA, TypeB)
- `file.ts` imports from `dep2.ts` (uses: ServiceC)

### Reverse Dependencies (imported by)
- `consumer1.ts` uses [specific export]
- `consumer2.ts` uses [specific export]

### Data Flow
[Source] -> [Transform 1] -> [Transform 2] -> [Destination]

### Impact of Changes
- **High impact**: [files that directly use the changed API]
- **Medium impact**: [files that use consumers of the changed API]
- **Low impact**: [files that are related but likely unaffected]
```

## WHEN TO STOP TRACING
- Stop at framework boundaries (don't trace into React internals or NestJS core)
- Stop at 3rd-party library boundaries (trace TO the library call, not INTO it)
- Stop at 3 levels of indirect consumers (beyond that, impact is speculative)
- Stop when you've answered the question the task asked -- don't trace for completeness
