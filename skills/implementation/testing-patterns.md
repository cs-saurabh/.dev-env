# Skill: Testing Patterns

## PURPOSE
Guide the implementation agent to write meaningful tests alongside code changes, covering unit, integration, and component testing across all stacks.

## TESTING PHILOSOPHY

- **Test behavior, not implementation**: Tests should verify what code does, not how it does it
- **Test the contract**: Focus on inputs, outputs, and side effects
- **One assertion per concept**: Each test should verify one logical behavior
- **Readable test names**: `should return paginated users when limit is provided` not `test1`

## REACT TESTING (Jest + React Testing Library)

### Component Tests
```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react';

describe('UserCard', () => {
  const mockUser = { id: '1', name: 'Saurabh', email: 'saurabh@example.com' };
  const mockOnSelect = jest.fn();

  it('should render user name and email', () => {
    render(<UserCard user={mockUser} onSelect={mockOnSelect} />);
    expect(screen.getByText('Saurabh')).toBeInTheDocument();
    expect(screen.getByText('saurabh@example.com')).toBeInTheDocument();
  });

  it('should call onSelect with user id when clicked', () => {
    render(<UserCard user={mockUser} onSelect={mockOnSelect} />);
    fireEvent.click(screen.getByRole('button'));
    expect(mockOnSelect).toHaveBeenCalledWith('1');
  });
});
```

### Redux Testing
- Test slices: verify reducers produce correct state for each action
- Test thunks: mock API calls, verify dispatched actions
- Test selectors: verify derived data computation

### Hook Testing
```typescript
import { renderHook, act } from '@testing-library/react-hooks';

it('should toggle value', () => {
  const { result } = renderHook(() => useToggle(false));
  expect(result.current[0]).toBe(false);
  act(() => result.current[1]());
  expect(result.current[0]).toBe(true);
});
```

## NESTJS TESTING (Jest)

### Service Tests
```typescript
describe('UserService', () => {
  let service: UserService;
  let repository: MockType<Repository<User>>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        UserService,
        { provide: getRepositoryToken(User), useFactory: repositoryMockFactory },
      ],
    }).compile();
    service = module.get(UserService);
    repository = module.get(getRepositoryToken(User));
  });

  it('should throw NotFoundException when user not found', async () => {
    repository.findOne.mockResolvedValue(null);
    await expect(service.findOne('nonexistent')).rejects.toThrow(NotFoundException);
  });
});
```

### Controller Tests (E2E)
```typescript
describe('UserController (e2e)', () => {
  it('/users (GET) should return paginated users', () => {
    return request(app.getHttpServer())
      .get('/users?limit=10')
      .expect(200)
      .expect((res) => {
        expect(res.body).toHaveLength(10);
      });
  });
});
```

## PYTHON TESTING (pytest)

```python
import pytest
from unittest.mock import AsyncMock, patch

class TestFeatureService:
    @pytest.fixture
    def service(self):
        return FeatureService(repo=AsyncMock())

    async def test_create_feature_returns_created_feature(self, service):
        service.repo.create.return_value = Feature(id="1", name="test")
        result = await service.create(CreateFeatureRequest(name="test"))
        assert result.id == "1"
        assert result.name == "test"

    async def test_create_feature_raises_on_duplicate_name(self, service):
        service.repo.create.side_effect = DuplicateKeyError("name")
        with pytest.raises(ConflictError):
            await service.create(CreateFeatureRequest(name="existing"))
```

## WHAT TO TEST FOR EACH CHANGE

| Change Type | Test |
|---|---|
| New function/method | Unit test: inputs -> outputs, edge cases, errors |
| New API endpoint | Integration test: request -> response, validation, auth |
| New component | Component test: renders correctly, user interactions, loading/error states |
| Bug fix | Regression test: reproduces the bug, verifies it's fixed |
| Refactor | Existing tests should still pass (add missing ones first) |

## ANTI-PATTERNS TO AVOID
- Don't test implementation details (internal state, private methods)
- Don't write tests that are brittle to UI changes (use roles/labels, not CSS selectors)
- Don't mock everything -- some integration is valuable
- Don't skip error case testing -- those are often where bugs hide
- Don't write tests after the fact as a checkbox -- write them as part of implementation
