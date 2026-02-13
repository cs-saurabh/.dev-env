# Skill: Library Source Code Reading

## PURPOSE
Guide library-expert agents to efficiently navigate and understand a library's source code to extract accurate component APIs, patterns, and implementation details.

## NAVIGATION STRATEGY

### Step 1: Find the Entry Point
Every library has an export map. Start here:
- `src/index.ts` or `src/index.js` -- barrel export, lists all public APIs
- `package.json` -> `main`, `module`, `exports` fields -- points to the build entry
- `src/components/index.ts` -- for component libraries

This tells you what the library EXPOSES and where each export lives.

### Step 2: Locate the Target Component/Module
From the entry point, follow the export to the actual source file:
```
src/index.ts -> exports { DateRangePicker } from './components/DateRangePicker'
-> Go to src/components/DateRangePicker/
-> Find: DateRangePicker.tsx (main component)
         DateRangePicker.types.ts (props interface)
         index.ts (component directory barrel)
```

### Step 3: Read the Props/API Interface
The most important file is the TypeScript interface:
- Look for `interface Props`, `type Props`, or `interface {Component}Props`
- Note which props are required vs optional
- Check for default values in the component's destructuring or `defaultProps`
- Look for generic type parameters

### Step 4: Understand Internal Behavior
Read the component implementation to understand:
- State management (useState, useReducer, internal state)
- Side effects (useEffect, event listeners, timers)
- Controlled vs uncontrolled behavior
- Event handler signatures (onChange, onSelect, etc.)
- Composition patterns (children, render props, compound components)

### Step 5: Find Usage Examples
Best source of "how to use this" is the library's own code:
- **Test files**: `*.test.tsx`, `*.spec.tsx` -- show how to render and interact
- **Story files**: `*.stories.tsx` -- show various configurations
- **Other components**: Search for internal usage of the component
- **Demo/example directories**: Some libraries include examples

## READING PATTERNS BY LIBRARY TYPE

### React Component Library
```
1. Component file -> understand rendering and behavior
2. Types file -> extract public API (props interface)
3. Hooks file -> understand custom hooks used internally
4. Styles file -> understand theming/customization points
5. Tests -> understand expected behavior and usage
```

### Utility Library
```
1. Function export -> understand signature and return type
2. Implementation -> understand transformation logic
3. Types -> understand input/output shapes
4. Tests -> understand edge cases and expected behavior
```

### API Client / SDK
```
1. Client class -> understand initialization and configuration
2. Methods -> understand available operations
3. Types -> understand request/response shapes
4. Error handling -> understand error types and recovery
```

## ACCURACY RULES

- **Never guess** -- if you can't find it in source, say "not found in source"
- **Always cite file paths** -- every fact should reference where you found it
- **Distinguish public from internal** -- only recommend using public APIs
- **Check for deprecation** -- look for `@deprecated` JSDoc tags or deprecation notices
- **Verify defaults** -- check both the interface (optional marker) and the implementation (default value in destructuring)
