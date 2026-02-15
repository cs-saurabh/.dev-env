---
name: semantic-merge
agent: git-conflict-resolver
type: workflow
description: "Resolve conflicts by understanding semantic intent of both sides and merging logic correctly"
---

# Skill: Semantic Merge

## PURPOSE
Resolve conflicts by understanding the semantic intent of both sides and producing a merged result that preserves the correct logic from each -- not just blindly accepting one side.

## CORE PRINCIPLE

**A conflict block is NOT a binary choice between current and incoming.** Often the correct resolution is a NEW version that takes specific parts from each side.

Example:
```
<<<<<<< HEAD
function processOrder(order: Order) {
  validateOrder(order);           // existing
  const discount = getDiscount(order.userId);  // CURRENT added this
  const total = calculateTotal(order.items);
  return { total: total - discount, status: 'processed' };
}
=======
function processOrder(order: Order) {
  validateOrder(order);           // existing
  const total = calculateTotal(order.items);
  logOrderMetrics(order);         // INCOMING added this
  return { total, status: 'processed' };
}
>>>>>>> feature/metrics
```

**Wrong**: Pick one side (loses either discount or metrics)
**Right**: Merge both additions:
```typescript
function processOrder(order: Order) {
  validateOrder(order);
  const discount = getDiscount(order.userId);  // from current
  const total = calculateTotal(order.items);
  logOrderMetrics(order);                       // from incoming
  return { total: total - discount, status: 'processed' };  // merged return
}
```

## SEMANTIC MERGE PROCESS

### Step 1: Identify the Common Ancestor
What did this code look like BEFORE either branch changed it?
- The lines that are identical on both sides = unchanged from ancestor
- The lines unique to current side = current branch additions/modifications
- The lines unique to incoming side = incoming branch additions/modifications

### Step 2: Classify Each Line
For each line in the conflict block, mark it:
- `[UNCHANGED]` -- same on both sides, keep as-is
- `[CURRENT-ONLY]` -- only in current branch, was added/modified by current
- `[INCOMING-ONLY]` -- only in incoming branch, was added/modified by incoming
- `[BOTH-MODIFIED]` -- exists on both sides but changed differently (the real conflict)

### Step 3: Merge Strategy Per Classification
- `[UNCHANGED]` -> keep
- `[CURRENT-ONLY]` -> keep (unless it conflicts with incoming's intent)
- `[INCOMING-ONLY]` -> keep (unless it conflicts with current's intent)
- `[BOTH-MODIFIED]` -> **THIS is where you need judgment:**
  - If both changes are additive and independent -> keep both
  - If one is a refinement of the other -> keep the refinement
  - If they're truly contradictory -> **ASK THE USER**

### Step 4: Verify Coherence
After merging, read the result as a complete unit:
- Does the logic flow make sense?
- Are variables used before they're declared?
- Are return values consistent with the merged logic?
- Do the merged additions interact correctly (e.g., one uses a variable the other defines)?

## MERGE PATTERNS

### Pattern: Both Added Independent Lines
```
// Just combine both additions, respecting logical ordering
```

### Pattern: Both Modified Same Line Differently
```
// Current: const timeout = 5000;
// Incoming: const timeout = 10000;
// -> ASK USER: which timeout value is correct?
```

### Pattern: One Restructured, Other Added
```
// Current: added new parameter to function
// Incoming: refactored function to use options object
// -> Keep the refactor (structural improvement) + add the new parameter to the options object
```

### Pattern: One Deleted Lines, Other Modified Them
```
// Current: removed deprecated validation
// Incoming: added new field to validation
// -> ASK USER: was the removal intentional? Should new field go in replacement validation?
```

## WHEN TO ASK THE USER (NON-NEGOTIABLE)

You MUST ask the user when:
- Two lines have different values and you can't determine which is correct
- Code was deleted on one side and modified on the other
- Business logic differs and both seem valid
- You're merging code in a domain you don't fully understand
- The merged result changes behavior in a way that might be unintended
- You have less than high confidence that your resolution preserves both intents

**Format your question with full context so the user can decide quickly.**
