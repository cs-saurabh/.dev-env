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

### Selector Patterns (Redux)
- Use `createSelector` from reselect for derived data
- Co-locate selectors with slices
- Name selectors: `selectFeatureItems`, `selectIsFeatureLoading`

### Zustand Patterns

#### Store Definition (Type-Safe)
```typescript
import { create } from 'zustand';
import { immer } from 'zustand/middleware/immer';
import { persist, createJSONStorage } from 'zustand/middleware';

// Separate state and actions into distinct types for clarity
interface FeatureState {
  items: Item[];
  loading: boolean;
  error: string | null;
  selectedId: string | null;
}

interface FeatureActions {
  setItems: (items: Item[]) => void;
  addItem: (item: Item) => void;
  removeItem: (id: string) => void;
  setSelectedId: (id: string | null) => void;
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
  fetchItems: () => Promise<void>;
}

// Use create<State & Actions>()(...)  -- extra parentheses required for TypeScript
export const useFeatureStore = create<FeatureState & FeatureActions>()(
  immer((set, get) => ({
    // State
    items: [],
    loading: false,
    error: null,
    selectedId: null,

    // Actions -- immer allows direct mutation syntax (immutable under the hood)
    setItems: (items) => set((state) => { state.items = items; }),
    addItem: (item) => set((state) => { state.items.push(item); }),
    removeItem: (id) => set((state) => {
      state.items = state.items.filter((item) => item.id !== id);
    }),
    setSelectedId: (id) => set((state) => { state.selectedId = id; }),
    setLoading: (loading) => set((state) => { state.loading = loading; }),
    setError: (error) => set((state) => { state.error = error; }),

    // Async actions
    fetchItems: async () => {
      set((state) => { state.loading = true; state.error = null; });
      try {
        const items = await featureApi.getItems();
        set((state) => { state.items = items; state.loading = false; });
      } catch (error) {
        set((state) => {
          state.error = error instanceof Error ? error.message : 'Failed to fetch';
          state.loading = false;
        });
      }
    },
  }))
);
```

#### Slices Pattern (Large Stores)
Split large stores into slices, then combine into a single bounded store:
```typescript
// slices/itemsSlice.ts
export interface ItemsSlice {
  items: Item[];
  addItem: (item: Item) => void;
}
export const createItemsSlice: StateCreator<ItemsSlice & FiltersSlice, [['zustand/immer', never]], [], ItemsSlice> = (set) => ({
  items: [],
  addItem: (item) => set((state) => { state.items.push(item); }),
});

// slices/filtersSlice.ts
export interface FiltersSlice {
  filters: Record<string, string>;
  setFilter: (key: string, value: string) => void;
}
export const createFiltersSlice: StateCreator<ItemsSlice & FiltersSlice, [['zustand/immer', never]], [], FiltersSlice> = (set) => ({
  filters: {},
  setFilter: (key, value) => set((state) => { state.filters[key] = value; }),
});

// store.ts -- combine slices, apply middleware HERE (not on individual slices)
export const useStore = create<ItemsSlice & FiltersSlice>()(
  immer((...a) => ({
    ...createItemsSlice(...a),
    ...createFiltersSlice(...a),
  }))
);
```

#### Selectors (Zustand)
Use selectors to subscribe to specific state parts and prevent unnecessary re-renders:
```typescript
// Inline selectors -- component only re-renders when selected value changes
const items = useFeatureStore((state) => state.items);
const loading = useFeatureStore((state) => state.loading);

// Derived selectors -- extract into reusable functions
const selectActiveItems = (state: FeatureState) =>
  state.items.filter((item) => item.isActive);
const selectItemCount = (state: FeatureState) => state.items.length;

// Usage in component
const activeItems = useFeatureStore(selectActiveItems);
const count = useFeatureStore(selectItemCount);

// Multiple values -- use useShallow to prevent re-renders on unchanged values
import { useShallow } from 'zustand/react/shallow';
const { items, loading, error } = useFeatureStore(
  useShallow((state) => ({ items: state.items, loading: state.loading, error: state.error }))
);
```

#### Persist Middleware
Persist state across page reloads:
```typescript
export const useSettingsStore = create<SettingsState & SettingsActions>()(
  persist(
    immer((set) => ({
      theme: 'light',
      locale: 'en',
      setTheme: (theme) => set((state) => { state.theme = theme; }),
      setLocale: (locale) => set((state) => { state.locale = locale; }),
    })),
    {
      name: 'app-settings',                          // unique localStorage key
      storage: createJSONStorage(() => localStorage), // default, can use sessionStorage
      partialize: (state) => ({ theme: state.theme, locale: state.locale }), // persist only selected fields
      version: 1,                                     // schema version for migrations
      migrate: (persistedState, version) => {         // handle schema changes
        if (version === 0) { /* migration logic */ }
        return persistedState as SettingsState & SettingsActions;
      },
    }
  )
);
```

#### Zustand Best Practices Summary
- **Always use `create<Type>()()`** with explicit types + extra parentheses for TypeScript
- **Use `immer` middleware** for clean mutation syntax on complex nested state
- **Use the slices pattern** for stores with 10+ state fields -- split by domain
- **Apply middleware to the combined store**, never to individual slices
- **Always use selectors** -- never subscribe to the entire store (`useStore()` without a selector triggers re-render on ANY change)
- **Use `useShallow`** when selecting multiple values as an object
- **Keep actions in the store**, not in components -- components should call `store.action()`, not `store.setState()`
- **One store per domain** -- don't put everything in a single global store
- **Use `persist` with `partialize`** to persist only the fields that need to survive page reloads
- **Name stores descriptively**: `useFeatureStore`, `useAuthStore`, `useSettingsStore`

#### Zustand File Organization
```
src/store/
├── featureStore.ts       # single-file store (small stores)
├── authStore.ts
├── settingsStore.ts
└── dashboard/            # sliced store (large stores)
    ├── store.ts          # combined store
    ├── slices/
    │   ├── widgetsSlice.ts
    │   ├── filtersSlice.ts
    │   └── layoutSlice.ts
    └── selectors.ts      # shared/derived selectors
```

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
