---
name: file-change-mapping
agent: planning
type: workflow
description: "Map exactly which files need to be created, modified, or deleted for a given task"
---

# Skill: File Change Mapping

## PURPOSE
Identify exactly which files need to be created, modified, or deleted for a given task. This feeds directly into the implementation plan's step-by-step structure.

## MAPPING PROCESS

### Step 1: Identify the Change Surface
From the codebase-intelligence context, determine:
- Which existing files need modification?
- Which new files need to be created?
- Which files might be deleted or deprecated?
- Which files are read-only dependencies (important but not changing)?

### Step 2: Categorize Changes
For each file in the change surface:
```
- `path/to/file.ts` [MODIFY] -- [what changes and why]
- `path/to/new-file.ts` [CREATE] -- [what this new file does]
- `path/to/old-file.ts` [DELETE] -- [why it's being removed]
- `path/to/dep.ts` [READ-ONLY] -- [why it matters but isn't changing]
```

### Step 3: Order by Dependency
Map the dependency graph between changed files:
- Which files must be changed first (types, schemas, interfaces)?
- Which files depend on the changes above (implementations)?
- Which files can be changed independently (parallel-safe)?

### Step 4: Estimate Scope
Count the change surface:
- **Small**: 1-3 files modified/created
- **Medium**: 4-8 files
- **Large**: 9+ files
- **Cross-repo**: Multiple repos involved

## COMMON CHANGE PATTERNS

### New API Endpoint (NestJS)
```
CREATE: src/modules/{feature}/{feature}.dto.ts        -- request/response DTOs
MODIFY: src/modules/{feature}/{feature}.service.ts     -- add service method
MODIFY: src/modules/{feature}/{feature}.controller.ts  -- add route handler
MODIFY: src/modules/{feature}/{feature}.module.ts      -- if new providers needed
CREATE: src/modules/{feature}/tests/{feature}.spec.ts  -- tests
```

### New React Feature
```
CREATE: src/components/{Feature}/{Feature}.tsx          -- component
CREATE: src/components/{Feature}/{Feature}.styles.ts    -- styles
CREATE: src/components/{Feature}/{Feature}.test.tsx     -- tests
MODIFY: src/store/slices/{feature}Slice.ts             -- state management
MODIFY: src/services/{feature}Service.ts               -- API client
MODIFY: src/routes/index.tsx                           -- routing (if new page)
```

### Cross-Repo API Contract Change
```
REPO A (Backend):
  MODIFY: src/modules/{feature}/{feature}.dto.ts       -- update DTO
  MODIFY: src/modules/{feature}/{feature}.controller.ts -- update endpoint

REPO B (Frontend):
  MODIFY: src/types/{feature}.types.ts                 -- update TypeScript types
  MODIFY: src/services/{feature}Service.ts             -- update API client
  MODIFY: src/components/{Feature}/{Feature}.tsx        -- update component
```

## OUTPUT FORMAT

```
## File Change Map: [Task Name]

### Scope: [Small/Medium/Large/Cross-repo]
### Files: [X modified, Y created, Z deleted]

### Change Order:
1. [First group -- foundation changes]
   - `file.ts` [MODIFY] -- [what]
2. [Second group -- depends on group 1]
   - `file.ts` [CREATE] -- [what]
3. [Third group -- depends on group 2]
   - `file.ts` [MODIFY] -- [what]

### Parallel-Safe Changes:
- `fileA.ts` and `fileB.ts` can be modified independently
```
