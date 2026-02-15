---
name: python-patterns
agent: implementation
type: patterns
description: "Write clean, idiomatic Python code following PEP 8 and modern best practices"
---

# Skill: Python Patterns

## PURPOSE
Guide the implementation agent to write clean, idiomatic Python code following PEP 8 and modern Python best practices.

## CODE STYLE

### Type Hints (Always Use)
```python
from typing import Optional, List, Dict, Any
from dataclasses import dataclass

def process_items(
    items: List[Dict[str, Any]],
    filter_key: str,
    limit: Optional[int] = None,
) -> List[Dict[str, Any]]:
    """Process and filter items by key."""
    filtered = [item for item in items if filter_key in item]
    return filtered[:limit] if limit else filtered
```

### Dataclasses for Data Structures
```python
@dataclass
class ProcessingResult:
    success: bool
    records_processed: int
    errors: List[str]
    duration_ms: float
```

### Naming Conventions
- `snake_case` for functions, variables, methods, modules
- `PascalCase` for classes
- `UPPER_SNAKE_CASE` for constants
- `_private_prefix` for internal-use names
- Descriptive names -- `user_records` not `ur`, `is_valid` not `iv`

## FASTAPI PATTERNS

### Route Structure
```python
from fastapi import APIRouter, Depends, HTTPException, status

router = APIRouter(prefix="/features", tags=["features"])

@router.get("/", response_model=List[FeatureResponse])
async def list_features(
    skip: int = 0,
    limit: int = 100,
    service: FeatureService = Depends(get_feature_service),
) -> List[FeatureResponse]:
    return await service.list_features(skip=skip, limit=limit)

@router.post("/", response_model=FeatureResponse, status_code=status.HTTP_201_CREATED)
async def create_feature(
    payload: CreateFeatureRequest,
    service: FeatureService = Depends(get_feature_service),
) -> FeatureResponse:
    return await service.create_feature(payload)
```

### Pydantic Models
```python
from pydantic import BaseModel, Field

class CreateFeatureRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = None
    tags: List[str] = Field(default_factory=list)

class FeatureResponse(BaseModel):
    id: str
    name: str
    created_at: datetime

    class Config:
        from_attributes = True  # for ORM model conversion
```

## DATA PROCESSING PATTERNS

### Pipeline Pattern
```python
def process_pipeline(raw_data: pd.DataFrame) -> pd.DataFrame:
    return (
        raw_data
        .pipe(clean_columns)
        .pipe(filter_invalid_rows)
        .pipe(transform_dates)
        .pipe(calculate_metrics)
    )
```

### Error Handling
```python
# Specific exceptions, not bare except
try:
    result = await external_api.fetch(resource_id)
except ConnectionError as e:
    logger.error(f"API connection failed: {e}")
    raise ServiceUnavailableError(f"External API unreachable: {e}")
except ValueError as e:
    logger.warning(f"Invalid response: {e}")
    raise BadRequestError(f"Invalid data received: {e}")
```

## ASYNC PATTERNS

- Use `async/await` for I/O-bound operations (API calls, DB queries, file I/O)
- Use `asyncio.gather()` for parallel async operations
- Don't mix sync and async carelessly -- sync operations in async context block the event loop
- Use `aiohttp` for async HTTP, not `requests`

## FILE ORGANIZATION
```
src/
├── main.py              # entry point
├── config.py            # configuration and env vars
├── models/              # data models (Pydantic, ORM)
├── services/            # business logic
├── routes/              # API route handlers
├── utils/               # shared utilities
└── tests/
    ├── test_services/
    └── test_routes/
```

## ANTI-PATTERNS TO AVOID
- Don't use mutable default arguments (`def fn(items=[])` -- use `None` and create inside)
- Don't catch bare `Exception` unless re-raising
- Don't use global state for configuration -- use dependency injection or config objects
- Don't ignore type hints -- they prevent bugs and help other agents understand code
- Don't write long functions -- if it's over 30 lines, consider splitting
