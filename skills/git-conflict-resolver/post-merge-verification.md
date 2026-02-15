---
name: post-merge-verification
agent: git-conflict-resolver
type: checklist
description: "Verify merged result is correct and won't introduce silent bugs before committing"
---

# Skill: Post-Merge Verification

## PURPOSE
After all conflicts are resolved, verify the merged result is correct, complete, and won't introduce silent bugs before the user commits.

## VERIFICATION CHECKLIST

### 1. No Remaining Conflict Markers
Search the entire repository for leftover markers:
```bash
grep -rn "<<<<<<< " --include="*.ts" --include="*.tsx" --include="*.js" --include="*.py" .
grep -rn "=======" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.py" .
grep -rn ">>>>>>> " --include="*.ts" --include="*.tsx" --include="*.js" --include="*.py" .
```
Even ONE remaining marker means an incomplete resolution.

### 2. Import Consistency
For each resolved file, verify:
- All imports reference files/modules that exist
- No duplicate imports
- No unused imports from a removed conflict side
- Named imports match actual exports from the source

### 3. Type Consistency
If type definitions were in conflict:
- All consumers of changed types still match the resolved type
- No type errors from mismatched interfaces
- Generic type parameters are consistent

### 4. Logic Flow Verification
Read each resolved file as a complete unit:
- Variables are declared before use
- Functions that were renamed are called by the new name everywhere
- Return types match what callers expect
- No dead code from a partially kept conflict side
- Control flow (if/else, try/catch, loops) has matching braces and complete paths

### 5. Cross-File Consistency
If conflicts spanned multiple files:
- API contracts (function signatures, HTTP endpoints) match between caller and callee
- Shared state (Redux actions/reducers, context) is consistent
- Event names and payloads match between emitter and listener
- Database schema matches ORM entities/models

### 6. Linter / Compiler Check
If available, run:
```bash
# TypeScript
npx tsc --noEmit

# ESLint
npx eslint --no-error-on-unmatched-pattern <resolved-files>

# Python
python -m py_compile <resolved-files>
pylint <resolved-files>
```

### 7. Test Sanity (If Quick)
If the project has fast-running tests for the affected area:
```bash
npm test -- --testPathPattern="<affected-module>"
pytest tests/<affected-module>/
```

## VERIFICATION OUTPUT

```
## Post-Merge Verification

### Conflict Markers
[PASS / FAIL] -- [X] remaining markers found in [files]

### Import Consistency
[PASS / WARN] -- [details of any issues]

### Type Consistency
[PASS / WARN] -- [details of any type mismatches]

### Logic Flow
[PASS / WARN] -- [details of any logic concerns]

### Cross-File Consistency
[PASS / WARN] -- [details of any cross-file issues]

### Linter/Compiler
[PASS / FAIL / SKIPPED] -- [output summary]

### Overall Verdict
[CLEAN -- ready to commit / ISSUES FOUND -- see above]
```

## COMMON POST-MERGE BUGS

### Silent Data Loss
A field was dropped during merge -- code compiles but data is missing at runtime.
**Check**: Compare the resolved code's data handling with both original branches.

### Duplicate Logic
Both sides' code was kept but they do the same thing, causing double execution.
**Check**: Look for duplicated function calls, event listeners, API requests.

### Broken Control Flow
An if/else or try/catch was partially merged, creating unreachable code or missing error handling.
**Check**: Trace every code path through the merged result.

### Stale References
A function/variable was renamed in one conflict but an old reference survived from the other side.
**Check**: Search for the old name in all resolved files.

## WHEN VERIFICATION FAILS

If verification finds issues:
1. Report the specific issue with file and line reference
2. Explain what went wrong in the merge
3. Propose a fix
4. **ASK THE USER before applying the fix** -- don't silently modify already-resolved code
