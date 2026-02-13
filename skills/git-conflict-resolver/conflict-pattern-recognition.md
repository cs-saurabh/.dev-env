# Skill: Conflict Pattern Recognition

## PURPOSE
Identify common, predictable conflict patterns that have reliable resolution strategies -- enabling fast, confident resolution for the easy cases so more time is spent on the hard ones.

## AUTO-RESOLVABLE PATTERNS (High Confidence)

### Pattern: Both Added Imports
```
<<<<<<< HEAD
import { existingA } from './module';
import { newFromCurrent } from './currentModule';
=======
import { existingA } from './module';
import { newFromIncoming } from './incomingModule';
>>>>>>> feature
```
**Resolution**: Keep both imports. Check for naming conflicts.
**Confidence**: High

### Pattern: Both Added to a List/Array
```
<<<<<<< HEAD
const routes = [
  '/users',
  '/products',
  '/orders',    // current added
];
=======
const routes = [
  '/users',
  '/products',
  '/analytics', // incoming added
];
>>>>>>> feature
```
**Resolution**: Keep both additions. Check for duplicates. Maintain alphabetical/logical ordering if the file uses one.
**Confidence**: High

### Pattern: Both Added Methods to a Class/Object
Both branches added different methods to the same class or object.
**Resolution**: Keep both methods. Verify no naming conflicts.
**Confidence**: High

### Pattern: Adjacent Line Edits (False Conflict)
Git flagged a conflict because changes are close together, but they don't actually overlap:
```
<<<<<<< HEAD
const name = user.firstName;     // current changed this line
const email = user.email;
const role = 'admin';            // unchanged
=======
const name = user.name;          // unchanged
const email = user.primaryEmail; // incoming changed this line
const role = 'admin';            // unchanged
>>>>>>> feature
```
**Resolution**: Keep current's line 1 change + incoming's line 2 change.
**Confidence**: High

## SEMI-AUTO PATTERNS (Medium Confidence -- Verify)

### Pattern: Package.json Dependency Conflicts
Both branches added different dependencies or changed versions:
**Resolution**: Keep both additions. For version conflicts on the same package, take the higher version (usually). Then regenerate lockfile.
**Confidence**: Medium -- verify version compatibility.

### Pattern: One Side Reformatted
One branch ran a formatter (prettier, black), other made logic changes:
**Resolution**: Keep the logic changes, apply formatting. Or accept the formatted version and re-apply the logic change.
**Confidence**: Medium -- ensure logic changes aren't lost in formatting noise.

### Pattern: Config Value Changes
Both sides changed the same config value (timeout, limit, feature flag):
**Resolution**: **ASK USER** -- you can't know which value is correct.
**Confidence**: Low -- business decision.

## NEVER-AUTO-RESOLVE PATTERNS (Always Ask User)

### Pattern: Delete vs Modify
One side deleted code, other side modified it.
**Always ask**: Was the deletion intentional? Is the modification still relevant?

### Pattern: Contradictory Logic
Both sides changed the same business logic in different directions.
**Always ask**: Which behavior is desired? Or is a new combined behavior needed?

### Pattern: Test Conflicts with Changed Expectations
Both sides changed expected values in tests.
**Always ask**: Which expectation matches the current desired behavior?

### Pattern: Database Migration / Schema Conflicts
Both sides added migrations or changed schemas.
**Always ask**: Migration ordering matters. User must decide sequence.

## LOCKFILE HANDLING (Special Rule)

**NEVER manually merge lockfiles.** Always:
1. Accept either side's `package.json` (resolve that first)
2. Delete the lockfile
3. Regenerate: `npm install` / `yarn install` / `pip freeze`
4. Stage the regenerated lockfile

## RECOGNITION CHECKLIST

When you encounter a conflict block, quickly classify:
- [ ] Is this a both-added pattern? -> Auto-resolve
- [ ] Is this an adjacent-line false conflict? -> Auto-resolve
- [ ] Is this a format-only change on one side? -> Apply logic + format
- [ ] Is this a parallel edit to the same logic? -> Semantic merge needed
- [ ] Is this delete vs modify? -> ASK USER
- [ ] Is this a config/value conflict? -> ASK USER
- [ ] Is this a lockfile? -> Regenerate
