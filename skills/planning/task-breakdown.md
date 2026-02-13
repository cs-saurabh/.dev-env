# Skill: Task Breakdown

## PURPOSE
Decompose complex development tasks into specific, ordered, independently executable steps that the implementation agent can follow as a todo list.

## BREAKDOWN PRINCIPLES

### The Todo Rule
Every step you produce must be:
- **Specific**: Names exact files, functions, and changes (not "update the component")
- **Ordered**: Dependencies between steps are respected
- **Testable**: Has a clear "done" criteria
- **Atomic**: One logical change per step (can be committed independently)
- **Sized right**: Completable in a single focused effort (not multi-hour steps)

### Decomposition Strategy

**Top-Down Decomposition:**
1. Start with the end result -- what should work when we're done?
2. Identify the major layers/areas that need changes (DB, API, Frontend, etc.)
3. Break each layer into specific file-level changes
4. Order by dependency: schema -> model -> service -> controller -> frontend -> tests

**Dependency-First Ordering:**
- Database/schema changes before code that uses them
- Type definitions before implementations that use those types
- Backend endpoints before frontend that calls them
- Utility functions before features that use them
- Core changes before dependent module changes

### Step Size Guidelines
- **Too big**: "Implement the user dashboard" -> needs further breakdown
- **Right size**: "Add `getUserStats` method to `UserService` that queries monthly active sessions"
- **Too small**: "Import the UserService" -> this is part of a larger step

## BREAKDOWN TEMPLATES

### Feature Implementation
```
1. [Data Layer] Add/modify database schema or types
2. [Data Layer] Update model/entity if needed
3. [Backend] Add service method with business logic
4. [Backend] Add controller endpoint
5. [Backend] Add validation DTOs
6. [Frontend] Add API client method
7. [Frontend] Add state management (Redux slice/thunk/selector)
8. [Frontend] Build UI component
9. [Frontend] Connect component to state and routes
10. [Testing] Add unit tests for service logic
11. [Testing] Add integration test for endpoint
```

### Bug Fix
```
1. [Diagnosis] Confirm root cause from debugging agent output
2. [Fix] Apply the specific code fix
3. [Guard] Add validation/check to prevent recurrence
4. [Test] Add test case that reproduces the bug (now passes)
5. [Verify] Confirm fix doesn't break related functionality
```

### Refactoring
```
1. [Prep] Add tests for current behavior (if missing)
2. [Refactor] Extract/rename/restructure (one change at a time)
3. [Update] Fix all consumers of the refactored code
4. [Verify] Run existing tests to confirm no regressions
5. [Clean] Remove dead code or deprecated patterns
```

## SPRINT-LEVEL BREAKDOWN

When breaking down an epic or large feature into sprint-sized tasks:
- Each task should be 1-3 days of work
- Each task should deliver a vertical slice (not "all backend then all frontend")
- Each task should be independently demoable or testable
- Include effort estimates: S (< 1 day), M (1-2 days), L (2-3 days)
- Flag dependencies between tasks explicitly
