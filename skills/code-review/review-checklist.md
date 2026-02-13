# Skill: Code Review Checklist

## PURPOSE
Provide a systematic review framework so the code-review agent catches issues consistently and doesn't miss critical problems.

## REVIEW PASS ORDER

Perform the review in this order -- critical issues first, style last.

### Pass 1: Correctness
- [ ] Does the code do what it's supposed to?
- [ ] Are all code paths handled (if/else, switch default, try/catch)?
- [ ] Are edge cases addressed (null, undefined, empty arrays, 0, negative numbers)?
- [ ] Are async operations properly awaited?
- [ ] Are promises handled (no unhandled rejections)?
- [ ] Do loops terminate correctly (no off-by-one, no infinite loops)?
- [ ] Are comparisons correct (=== not ==, proper null checks)?

### Pass 2: Security
- [ ] Is user input validated and sanitized before use?
- [ ] Are SQL/NoSQL queries parameterized (no injection vulnerabilities)?
- [ ] Are authentication checks in place for protected routes?
- [ ] Are authorization checks verifying the user has permission?
- [ ] Are secrets/keys coming from environment variables (not hardcoded)?
- [ ] Is sensitive data excluded from logs and error messages?
- [ ] Are CORS settings appropriate?
- [ ] Is file upload handling secure (type validation, size limits)?

### Pass 3: Performance
- [ ] Are there N+1 query patterns (looping database calls)?
- [ ] Are large datasets paginated?
- [ ] Are expensive computations memoized or cached?
- [ ] Are React components avoiding unnecessary re-renders (memo, useMemo, useCallback)?
- [ ] Are database queries using appropriate indexes?
- [ ] Are API responses reasonably sized (not returning entire collections)?
- [ ] Are there potential memory leaks (event listeners, subscriptions, intervals not cleaned up)?

### Pass 4: Maintainability
- [ ] Is the code readable without requiring explanation?
- [ ] Are names descriptive and consistent with the codebase?
- [ ] Is the logic at an appropriate abstraction level (not too abstract, not too concrete)?
- [ ] Is there code duplication that should be extracted?
- [ ] Are functions focused (single responsibility)?
- [ ] Is the file structure logical and consistent?

### Pass 5: Types and Contracts
- [ ] Are TypeScript types specific (no `any`, no unnecessary type assertions)?
- [ ] Do function signatures accurately describe inputs and outputs?
- [ ] Are API contracts (DTOs, request/response shapes) properly defined?
- [ ] Are optional vs required fields correctly marked?

### Pass 6: Testing
- [ ] Are there tests for the new/changed functionality?
- [ ] Do tests cover both happy path and error cases?
- [ ] Are tests testing behavior (not implementation details)?
- [ ] Are mocks minimal and appropriate?

## SEVERITY CLASSIFICATION

**CRITICAL** (Must fix before merge):
- Bugs, security vulnerabilities, data loss potential, broken functionality

**MAJOR** (Should fix before merge):
- Performance issues, missing error handling, missing validation, incorrect types

**MINOR** (Fix when convenient):
- Naming improvements, minor style issues, documentation gaps

**NIT** (Optional, author's choice):
- Personal style preferences, alternative approaches, minor optimizations
