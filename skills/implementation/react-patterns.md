# Skill: React / TypeScript Patterns

## PURPOSE
Guide the implementation agent to write React code that follows modern best practices and matches common project conventions.

## COMPONENT PATTERNS

### Functional Components with TypeScript
```typescript
// Always use interface for props (not type alias) for consistency
interface UserCardProps {
  user: User;
  onSelect: (userId: string) => void;
  isActive?: boolean; // optional props with ?
}

// Named export, not default export (better for refactoring and tree-shaking)
export const UserCard: React.FC<UserCardProps> = ({ user, onSelect, isActive = false }) => {
  // hooks at the top
  // handlers in the middle
  // return JSX at the bottom
};
```

### Custom Hooks
- Extract reusable logic into `use*` hooks
- Keep hooks focused -- one responsibility per hook
- Return both data and actions: `const { data, isLoading, error, refetch } = useUserData(userId)`
- Place in `hooks/` directory or co-locate with the feature

### Component Composition
- Prefer composition over prop drilling for complex UIs
- Use children and render props for flexible components
- Use React.Context sparingly -- only for truly global state (theme, auth, locale)

## STATE MANAGEMENT

### Redux Toolkit Patterns
```typescript
// createSlice with typed state
interface FeatureState {
  items: Item[];
  loading: boolean;
  error: string | null;
}

const initialState: FeatureState = { items: [], loading: false, error: null };

const featureSlice = createSlice({
  name: 'feature',
  initialState,
  reducers: {
    // synchronous actions
  },
  extraReducers: (builder) => {
    // async thunk handling
    builder
      .addCase(fetchItems.pending, (state) => { state.loading = true; })
      .addCase(fetchItems.fulfilled, (state, action) => {
        state.loading = false;
        state.items = action.payload;
      })
      .addCase(fetchItems.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message ?? 'Failed to fetch';
      });
  },
});
```

### Selector Patterns
- Use `createSelector` from reselect for derived data
- Co-locate selectors with slices
- Name selectors: `selectFeatureItems`, `selectIsFeatureLoading`

## ERROR HANDLING

### API Error Handling
- Catch errors in thunks, set error state in slice
- Display user-friendly error messages, not raw API errors
- Implement retry logic for transient failures
- Use error boundaries for unexpected render errors

### Form Validation
- Validate on blur for individual fields, on submit for the form
- Show inline errors next to the relevant field
- Use controlled components for forms that need real-time validation

## TYPESCRIPT GUIDELINES

- **Never use `any`** -- use `unknown` if the type is truly unknown, then narrow
- **Avoid type assertions** (`as Type`) -- prefer type guards
- **Use discriminated unions** for state that has multiple modes
- **Export interfaces** that other files need; keep internal types private
- **Use generics** for reusable components and hooks

## FILE ORGANIZATION
```
src/components/Feature/
├── Feature.tsx           # main component
├── Feature.styles.ts     # styled-components or CSS modules
├── Feature.test.tsx      # tests
├── Feature.types.ts      # types (if complex, otherwise inline)
├── useFeature.ts         # custom hook (if needed)
└── index.ts              # barrel export
```

## ANTI-PATTERNS TO AVOID
- Don't mutate state directly (even with Immer, be explicit)
- Don't use `useEffect` for derived state (use `useMemo` instead)
- Don't create components inside other components (causes remounting)
- Don't ignore dependency arrays in hooks
- Don't fetch data in components -- use thunks/services
