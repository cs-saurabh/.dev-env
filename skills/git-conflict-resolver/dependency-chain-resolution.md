# Skill: Dependency Chain Resolution

## PURPOSE
Trace how conflicts in one file or block affect other conflicts, ensuring that resolving conflict A doesn't create a broken state in conflict B.

## WHY THIS MATTERS

Conflicts don't exist in isolation. Common dependency chains:

```
types.ts (conflict in interface)
    |
    └──> service.ts (conflict uses that interface)
            |
            └──> controller.ts (conflict calls the service)
                    |
                    └──> component.tsx (conflict consumes the API)
```

If you resolve `types.ts` first (adding a new field), then `service.ts` must account for that field. Resolving them independently can produce code that compiles but has missing data flow.

## DEPENDENCY MAPPING PROCESS

### Step 1: List All Conflicted Files
```bash
git diff --name-only --diff-filter=U
```

### Step 2: Identify Dependencies Between Conflicted Files
For each conflicted file, check:
- Does it import from another conflicted file?
- Does it export something consumed by another conflicted file?
- Do they share types, interfaces, or constants?

### Step 3: Build Resolution Order
Resolve in dependency order (upstream first):
```
1. Type definitions / interfaces (no dependencies)
2. Shared utilities / constants
3. Services / business logic
4. Controllers / API handlers
5. Components / UI
6. Tests
7. Configuration files
8. Lockfiles (regenerate last)
```

### Step 4: Propagate Decisions
When resolving an upstream file, track decisions that affect downstream:
```
Decision Log:
- types.ts: Kept incoming's new `timezone` field on DateRange interface
  -> service.ts must handle timezone in processing logic
  -> component.tsx must pass timezone from UI

- service.ts: Kept current's retry logic + incoming's new error type
  -> controller.ts must handle the new error type in catch blocks
```

## COMMON DEPENDENCY CHAINS

### Import Chain
File A's conflict adds a new export. File B's conflict imports from File A.
- Resolve A first
- In B, ensure the import matches A's resolved exports

### Type Chain
Interface changed in conflict. Multiple files use that interface in their conflicts.
- Resolve the interface first
- Propagate the type change to all consuming files

### Function Signature Chain
Function signature changed in one conflict. Call sites are in other conflicts.
- Resolve the function definition first
- Update all call sites to match new signature

### Re-export Chain
Index/barrel file has conflicts. Files that import via the barrel have conflicts.
- Resolve the barrel file first
- Ensure re-exports match resolved source files

## OUTPUT: RESOLUTION ORDER PLAN

```
## Conflict Resolution Order

### Phase 1: Foundation (resolve first)
- `src/types/user.ts` -- type definitions, no dependencies
  Blocks: 2 conflicts
  
### Phase 2: Core Logic (depends on Phase 1)
- `src/services/userService.ts` -- uses types from Phase 1
  Blocks: 3 conflicts
  Depends on: user.ts resolution
  
### Phase 3: Consumers (depends on Phase 2)
- `src/controllers/userController.ts` -- calls service from Phase 2
  Blocks: 1 conflict
  Depends on: userService.ts resolution

### Phase 4: UI (depends on Phase 2-3)
- `src/components/UserProfile.tsx` -- consumes API from Phase 3
  Blocks: 2 conflicts

### Phase 5: Peripheral
- `src/tests/user.test.ts` -- tests, resolve after source
- `package.json` -- dependencies, resolve manually
- `package-lock.json` -- regenerate after package.json
```
