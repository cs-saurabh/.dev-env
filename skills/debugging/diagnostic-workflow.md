---
name: diagnostic-workflow
agent: debugging
type: workflow
description: "Structured hypothesis-driven diagnosis process to find root causes efficiently"
---

# Skill: Systematic Diagnostic Workflow

## PURPOSE
Guide the debugging agent through a structured, hypothesis-driven diagnosis process to find root causes efficiently.

## THE DIAGNOSTIC LOOP

```
1. OBSERVE  -> What are the exact symptoms?
2. HYPOTHESIZE -> What are the 3 most likely causes?
3. TEST -> Read code/logs to confirm or eliminate each hypothesis
4. NARROW -> Update hypotheses based on evidence
5. CONFIRM -> Verify root cause explains ALL symptoms
6. PRESCRIBE -> Describe the fix for the implementation agent
```

### Step 1: OBSERVE
Gather all available evidence before forming hypotheses:
- What's the exact error message or unexpected behavior?
- When did it start? (recent deployment, code change, data change?)
- Is it consistent or intermittent?
- What's the expected behavior vs actual behavior?
- Which users/environments are affected?

### Step 2: HYPOTHESIZE
Form at least 3 hypotheses, ordered by likelihood:
```
Hypothesis 1 (most likely): [description] -- because [reasoning]
Hypothesis 2: [description] -- because [reasoning]
Hypothesis 3 (least likely): [description] -- because [reasoning]
```

Rules for good hypotheses:
- Each should be testable by reading specific code or logs
- Cover different categories (data issue, logic error, race condition, config problem)
- Don't anchor on the first idea -- force yourself to think of alternatives

### Step 3: TEST
For each hypothesis, identify what evidence would confirm or eliminate it:
```
To confirm H1: Read [specific file/function] and check [specific condition]
To eliminate H1: If [specific thing] is correct, H1 is ruled out
```

### Step 4: NARROW
After testing each hypothesis:
- Mark as CONFIRMED, ELIMINATED, or NEEDS_MORE_DATA
- If all eliminated, form new hypotheses based on what you learned
- If multiple confirmed, determine which is the root cause vs symptom

### Step 5: CONFIRM
The root cause must explain ALL symptoms:
- Does fixing this explain why [symptom 1] happens? Yes/No
- Does it explain why [symptom 2] happens? Yes/No
- Does it explain the timing/intermittence pattern? Yes/No
- If any answer is No, keep investigating

### Step 6: PRESCRIBE
Describe the fix clearly for the implementation agent:
- What file(s) to change
- What specifically to change
- Why this fixes the root cause
- What guard to add to prevent recurrence

## COMMON BUG PATTERNS

### Off-by-One
Look for: array indexing, loop boundaries, pagination offsets, date ranges

### Null/Undefined Access
Look for: optional chaining missing, destructuring without defaults, API responses with missing fields

### Race Conditions
Look for: concurrent state updates, async operations without proper sequencing, stale closures in React

### State Mutation
Look for: direct object/array mutation, Redux state modified outside reducers, shared references

### Type Mismatch
Look for: string vs number comparisons, date object vs string, API response shape changes
