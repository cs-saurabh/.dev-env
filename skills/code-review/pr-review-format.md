---
name: pr-review-format
agent: code-review
type: format
description: "Produce clear, constructive, and actionable review feedback"
---

# Skill: PR Review Format

## PURPOSE
Guide the code-review agent to produce clear, constructive, and actionable review feedback.

## REVIEW TONE

- **Be constructive**: Suggest improvements, don't just criticize
- **Explain why**: Every comment should include the reason, not just the issue
- **Acknowledge good work**: Call out well-written code -- it reinforces good patterns
- **Ask questions for ambiguity**: "Is this intentional?" rather than "This is wrong"
- **Offer alternatives**: "Consider using X because Y" rather than "Don't use Z"

## REVIEW STRUCTURE

### For Self-Review (Before PR)
```
## Pre-PR Review

### Ready to Ship?
[YES / NEEDS WORK]

### Issues Found
[List issues by severity, with file:line references and suggestions]

### Confidence Level
[HIGH / MEDIUM / LOW -- based on change complexity and test coverage]

### Checklist
- [ ] All tests pass
- [ ] No console.logs left (except intentional ones)
- [ ] Types are correct and specific
- [ ] Error handling is complete
- [ ] No hardcoded values that should be config
```

### For Teammate PR Review
```
## PR Review: [PR Title]

### Summary
[1-2 sentence assessment of the PR quality and readiness]

### What's Done Well
- [Positive observation 1]
- [Positive observation 2]

### Issues

**[CRITICAL]** `file.ts:42` -- [Issue description]
> [Code snippet or reference]
Suggestion: [How to fix]
Why: [Impact of not fixing]

**[MAJOR]** `file.ts:87` -- [Issue description]
Suggestion: [How to fix]

**[MINOR]** `file.ts:15` -- [Issue description]
Suggestion: [How to fix]

### Questions
- `file.ts:63` -- [Question about design decision or intent]

### Verdict
[APPROVE / REQUEST_CHANGES / NEEDS_DISCUSSION]
```

## COMMENT FORMATTING

### Inline Comments
When referencing specific code, always include:
- File path and line number
- The problematic code snippet (or reference)
- Why it's an issue
- What to do instead

### Blocking vs Non-Blocking
Mark comments clearly:
- **Blocking**: "This needs to be fixed before merge because..."
- **Non-blocking**: "Consider doing X for better readability (non-blocking)"
- **Question**: "Is this intentional? If so, a comment explaining why would help"

## WHAT NOT TO DO
- Don't review style that's already established in the codebase (follow, don't fight)
- Don't request changes for personal preferences
- Don't leave vague comments ("this could be better" -- HOW?)
- Don't approve without actually reading the code
- Don't pile on -- if there's a systemic issue, note it once with "applies throughout"
