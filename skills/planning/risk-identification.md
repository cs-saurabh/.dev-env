# Skill: Risk Identification

## PURPOSE
Identify risks, edge cases, and decisions that need user input BEFORE implementation begins. Preventing blockers is cheaper than resolving them mid-implementation.

## RISK CATEGORIES

### Technical Risks
- **Breaking changes**: Will this change break existing functionality?
- **Data migration**: Does this require migrating existing data?
- **API contract changes**: Will consumers of this API need to update?
- **Performance impact**: Could this degrade performance at scale?
- **Concurrency issues**: Could this cause race conditions?
- **Security implications**: Does this change authentication, authorization, or data access?

### Dependency Risks
- **Blocked by other work**: Does this depend on another feature or fix being done first?
- **External service dependency**: Does this rely on a third-party API or service?
- **Cross-repo coordination**: Do multiple repos need to be updated in a specific order?
- **Package version conflicts**: Could new dependencies conflict with existing ones?

### Ambiguity Risks
- **Unclear requirements**: Is the expected behavior fully specified?
- **Multiple valid approaches**: Are there design decisions that need user input?
- **Edge cases undefined**: What should happen in error states, empty states, boundary conditions?
- **Naming/convention decisions**: Are there naming choices that affect future code?

## RISK ASSESSMENT FORMAT

For each identified risk:
```
**Risk**: [Clear description of what could go wrong]
**Likelihood**: High / Medium / Low
**Impact**: High / Medium / Low
**Mitigation**: [How to prevent or handle it]
**Decision needed?**: Yes/No -- if yes, present options to the user
```

## DECISION POINTS

When the plan involves a design decision, present it clearly:
```
**Decision**: [What needs to be decided]
**Options**:
  A. [Option A] -- Pros: [benefits] / Cons: [drawbacks]
  B. [Option B] -- Pros: [benefits] / Cons: [drawbacks]
**Recommendation**: [Your suggestion and why]
**Impact of deferring**: [What happens if we decide later]
```

## PRE-FLIGHT CHECKLIST
Before finalizing any plan, verify:
- [ ] All assumptions are stated explicitly
- [ ] Breaking changes are identified and flagged
- [ ] Cross-repo dependencies are mapped
- [ ] Edge cases are addressed or flagged as needing input
- [ ] Rollback strategy exists for high-risk changes
- [ ] No ambiguity remains that could block the implementation agent
