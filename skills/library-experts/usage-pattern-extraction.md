---
name: usage-pattern-extraction
agent: library-experts
type: workflow
description: "Extract practical, implementable usage patterns from library source code"
---

# Skill: Usage Pattern Extraction

## PURPOSE
Guide library-expert agents to extract practical, implementable usage patterns from source code -- producing output that the implementation agent can directly act on.

## EXTRACTION PROCESS

### What to Extract
For each component/API requested, extract:
1. **Minimal usage** -- the simplest way to use it correctly
2. **Common usage** -- the typical configuration most consumers need
3. **Advanced usage** -- complex configurations for power users
4. **Anti-patterns** -- things that look right but don't work

### Where to Find Patterns

#### From Test Files (Most Reliable)
Test files show exactly how to render/call the component:
```typescript
// From: DateRangePicker.test.tsx
render(
  <DateRangePicker
    startDate={new Date('2024-01-01')}
    endDate={new Date('2024-01-31')}
    onChange={(range) => handleChange(range)}
  />
);
```
This IS a working usage pattern -- extract it.

#### From Story Files (Most Varied)
Storybook stories show multiple configurations:
```typescript
// From: DateRangePicker.stories.tsx
export const WithPresets = () => (
  <DateRangePicker
    presets={['last7days', 'last30days', 'thisMonth']}
    showPresetDropdown
    onChange={action('onChange')}
  />
);
```
Each story variant IS a usage pattern.

#### From Internal Usage (Most Realistic)
Other components in the library that compose this one:
```typescript
// From: FilterPanel.tsx (uses DateRangePicker internally)
<DateRangePicker
  value={dateRange}
  onChange={setDateRange}
  minDate={projectStartDate}
  maxDate={new Date()}
  disabled={isLoading}
/>
```
This shows real-world composition patterns.

## OUTPUT FORMAT FOR IMPLEMENTATION AGENT

Structure your output so the implementation agent can copy-paste and adapt:

```
## How to Use: [Component/API Name]

### Minimal Setup
[Smallest working example with only required props]
```tsx
<DateRangePicker
  onChange={(range) => console.log(range)}
/>
```

### Typical Usage
[Common configuration with frequently-used optional props]
```tsx
<DateRangePicker
  startDate={startDate}
  endDate={endDate}
  onChange={(range) => {
    setStartDate(range.startDate);
    setEndDate(range.endDate);
  }}
  minDate={new Date('2024-01-01')}
  placeholder="Select date range"
/>
```

### Props Quick Reference
| Prop | Type | Required | Default | Notes |
|------|------|----------|---------|-------|
| onChange | (range: DateRange) => void | Yes | - | Fires on selection |
| startDate | Date | No | null | Initial start |
| endDate | Date | No | null | Initial end |
| minDate | Date | No | - | Earliest selectable |
| maxDate | Date | No | - | Latest selectable |

### Gotchas
- [Common mistake 1 and how to avoid it]
- [Common mistake 2 and how to avoid it]

### Source References
- Component: `src/components/DateRangePicker/DateRangePicker.tsx`
- Types: `src/components/DateRangePicker/DateRangePicker.types.ts`
- Tests: `src/components/DateRangePicker/__tests__/DateRangePicker.test.tsx`
```

## QUALITY RULES

- Every code example must be derived from actual source code -- never invented
- Always include the source file path where you found the pattern
- If a prop's behavior is unclear from source, say so rather than guessing
- Include TypeScript types in examples -- the implementation agent needs them
- Note any peer dependencies the component requires (e.g., needs a Provider wrapper)
