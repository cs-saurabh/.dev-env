# Skill: Cross-Repo Type Synchronization

## PURPOSE
Guide the docs-and-contracts agent to maintain consistent TypeScript types and interfaces across frontend and backend repositories.

## THE SYNC PROBLEM

When frontend and backend are in separate repos, type definitions can drift:
- Backend adds a field but frontend doesn't know about it
- Frontend expects a field that backend renamed
- Enum values differ between repos
- Nullable fields handled differently

## SYNC STRATEGIES

### Strategy 1: Shared Types File (Manual Sync)
Maintain a canonical type definition and manually sync:

```typescript
// CANONICAL TYPE (define once, copy to both repos)

// Backend DTO (source of truth)
export interface UserResponse {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'editor' | 'viewer';
  lastLoginAt: string | null;  // ISO 8601 or null
  createdAt: string;           // ISO 8601
}

// Frontend type (must match)
export interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'editor' | 'viewer';
  lastLoginAt: string | null;
  createdAt: string;
}
```

### Strategy 2: API Response Type Generation
Backend DTOs are the source of truth. Frontend types derive from API responses:

```typescript
// Frontend: type derived from what the API actually returns
import { paths } from './api-schema'; // generated from OpenAPI spec

type UserResponse = paths['/api/users/{id}']['get']['responses']['200']['content']['application/json'];
```

### Strategy 3: Shared Package
If feasible, create a shared npm package with common types:
```
@company/shared-types/
├── src/
│   ├── user.types.ts
│   ├── project.types.ts
│   └── index.ts
└── package.json
```

Both repos depend on `@company/shared-types`.

## TYPE CHANGE WORKFLOW

When a type needs to change:

1. **Document the change** in the API contract first
2. **Update backend** DTO/entity with the new field/type
3. **Update shared types** or frontend types to match
4. **Check all consumers** in the frontend that use this type
5. **Update API client** methods if the request/response shape changed
6. **Verify** with TypeScript compiler -- type errors reveal missed updates

## COMMON SYNC ISSUES

### Field Casing
Backend returns `snake_case`, frontend expects `camelCase`:
- Solve with a serialization layer (NestJS interceptor or API client transformer)
- Document the casing convention explicitly

### Date Handling
Backend sends ISO strings, frontend needs Date objects:
- Keep as strings in types, convert in utility functions
- Document: "All dates are ISO 8601 strings in UTC"

### Enum Discrepancy
Backend has string enum, frontend has different values:
- Define enums in one place, import in both
- Never hardcode enum strings in components -- use the imported enum

### Optional vs Nullable
Backend sends `null`, frontend checks `undefined`:
- Agree on convention: `null` for "explicitly empty", `undefined` for "not included"
- Document in the API contract which fields can be null

## OUTPUT FORMAT

When documenting type sync changes:
```
## Type Sync: [Change Name]

### Changed Type
[Type name and what changed]

### Backend (source of truth)
[Updated DTO/interface with changes highlighted]

### Frontend (must update)
[Updated type with changes highlighted]

### Files to Update
- Backend: `src/modules/user/dto/user-response.dto.ts`
- Frontend: `src/types/user.types.ts`
- Frontend: `src/services/userService.ts` (if API call shape changed)
- Frontend: `src/components/UserProfile.tsx` (if consuming the changed field)
```
