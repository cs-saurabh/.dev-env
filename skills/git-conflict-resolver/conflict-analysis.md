---
name: conflict-analysis
agent: git-conflict-resolver
type: workflow
description: "Parse and categorize git conflict blocks to understand their structure and complexity"
---

# Skill: Conflict Analysis

## PURPOSE
Parse and categorize git conflict blocks to understand their structure, scope, and complexity before attempting resolution.

## CONFLICT ANATOMY

### Conflict Markers
```
<<<<<<< HEAD (or current branch name)
[Current branch code -- YOUR changes]
=======
[Incoming branch code -- THEIR changes]
>>>>>>> incoming-branch (or commit hash)
```

- **Above `=======`**: What's in your current branch (HEAD / ours)
- **Below `=======`**: What's coming from the branch being merged (theirs)

### Multi-Block Files
A single file can have multiple conflict blocks. Each block is independent but may be related:
- Block 1 might change an import, Block 2 might use that import
- Block 1 might rename a function, Block 3 might call that function
- **Always survey ALL blocks in a file before resolving ANY of them**

## CONFLICT CATEGORIZATION

### Category 1: Both-Added (Low Risk)
Both sides added new, non-overlapping content:
- Both added different imports
- Both added different entries to a list/array/config
- Both added different functions or methods
**Resolution**: Usually keep both. Check for duplicates or ordering conflicts.

### Category 2: Parallel Edit (Medium Risk)
Both sides modified the same existing code differently:
- Both changed a function's implementation
- Both modified the same config value
- Both updated the same CSS property
**Resolution**: Requires understanding WHAT each side changed and WHY. Often need semantic merge.

### Category 3: Divergent Refactor (High Risk)
One side refactored/restructured while the other modified:
- One renamed a function, other added new calls to old name
- One moved code to a new file, other modified it in the old location
- One changed a type signature, other added new code using old signature
**Resolution**: Requires tracing the refactor's impact. Keep the refactor + update the other side's changes to work with the new structure.

### Category 4: Delete vs Modify (High Risk -- ASK USER)
One side deleted code that the other side modified:
- One removed a function, other added logic to it
- One removed a file, other modified it
**Resolution**: ALWAYS ask the user. You cannot know if the deletion was intentional and the modification should be discarded, or vice versa.

### Category 5: Config/Lockfile (Special Handling)
Package managers, lockfiles, auto-generated configs:
- `package-lock.json`, `yarn.lock` -> delete and regenerate
- `package.json` dependencies -> keep both additions, resolve version conflicts manually
- Auto-generated files -> regenerate from source

## ANALYSIS OUTPUT

For each conflict block, produce:
```
File: path/to/file.ts
Block: [N] of [total] (lines X-Y)
Category: [1-5 from above]
Risk: [Low / Medium / High]
Current intent: [what the current branch was trying to do]
Incoming intent: [what the incoming branch was trying to do]
Overlap: [what specifically conflicts between the two intents]
Confidence: [High / Medium / Low -- can you resolve this confidently?]
```

If confidence is Low -> flag for user decision immediately.
