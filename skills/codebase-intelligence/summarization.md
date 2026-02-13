# Skill: Codebase Summarization

## PURPOSE
Produce concise, structured summaries that are immediately useful to the next agent in the pipeline (planning, implementation, debugging, etc.).

## SUMMARIZATION PRINCIPLES

### Write for Your Audience
Your summaries are read by OTHER AGENTS, not humans browsing documentation. They need:
- Specific file paths (not "the auth module" but `src/modules/auth/auth.service.ts`)
- Exact patterns in use (not "uses state management" but "Redux Toolkit with createSlice, async thunks for API calls, selectors with reselect")
- Actionable context (not "handles authentication" but "JWT-based auth, tokens stored in httpOnly cookies, refresh via /api/auth/refresh endpoint, guard at `src/guards/jwt-auth.guard.ts`")

### Conciseness Over Completeness
- Keep summaries under 500 words unless the task demands more
- Lead with the most important information
- Use bullet points for scannable content
- Omit details that aren't relevant to the current task

### Structure for Handoff
Every summary should answer these questions for the next agent:
1. **What exists?** -- Current state of the code
2. **Where is it?** -- Exact file paths
3. **How does it work?** -- Key patterns and data flow
4. **What matters for the task?** -- Specific details the next agent needs

## SUMMARY TEMPLATES

### For Implementation Handoff
```
## Context for Implementation: [Feature/Area]

### Current State
[What exists today, what patterns are in use]

### Key Files to Modify
- `path/to/file.ts` -- [what it does, what to change]

### Patterns to Follow
- [Convention 1 with example]
- [Convention 2 with example]

### Watch Out For
- [Gotcha or constraint the implementer needs to know]
```

### For Debugging Handoff
```
## Context for Debugging: [Issue Area]

### Relevant Code Path
[Entry point] -> [middleware] -> [handler] -> [service] -> [output]

### Recent Changes
[If identifiable, what changed recently in this area]

### State Management
[How state flows through the relevant path]

### Error Handling
[How errors are caught and propagated in this area]
```

### For Planning Handoff
```
## Context for Planning: [Feature/Area]

### Architecture Overview
[How the relevant area is structured]

### Dependencies
[What this area depends on, what depends on it]

### Change Surface
[Files and modules that would need to change]

### Constraints
[Technical constraints, framework limitations, or conventions to honor]
```

## QUALITY CHECKLIST
- [ ] Every file reference uses a real, verified path
- [ ] Patterns described match what's actually in the code (not assumed)
- [ ] Summary is scoped to the current task (not a general project overview)
- [ ] Actionable details are specific enough for another agent to act on
- [ ] Length is proportional to complexity -- don't over-summarize simple things
