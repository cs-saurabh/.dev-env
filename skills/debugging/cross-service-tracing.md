# Skill: Cross-Service Bug Tracing

## PURPOSE
Guide the debugging agent to trace bugs that span multiple services (frontend -> API -> database/external services).

## TRACING STRATEGY

### Identify the Boundary
First, determine WHERE the bug manifests vs where it originates:
- **Frontend shows wrong data** -> Is the API returning wrong data, or is the frontend mishandling correct data?
- **API returns an error** -> Is the error in the API logic, or from a downstream service/database?
- **Feature works in dev but not prod** -> Is it a configuration, data, or environment difference?

### Trace from Symptom to Source
Always trace in the direction of data flow:

```
1. Start at the SYMPTOM (where the user sees the problem)
2. Check the data at that point (component state, API response)
3. Move ONE layer back (API call, service method, DB query)
4. Check the data at that point
5. Repeat until you find where CORRECT data becomes INCORRECT
6. That boundary is where the bug lives
```

### Cross-Service Trace Template

```
## Trace: [Bug Description]

### Layer 1: Frontend
- Component: [path]
- Data received: [what the component has]
- Expected: [what it should have]
- Verdict: [Data is correct/incorrect at this layer]

### Layer 2: API Client
- Service call: [path, method]
- Request sent: [params, body]
- Response received: [data shape and content]
- Verdict: [Data is correct/incorrect at this layer]

### Layer 3: Backend Controller
- Endpoint: [route]
- Request received: [what the controller gets]
- Response sent: [what the controller returns]
- Verdict: [Data is correct/incorrect at this layer]

### Layer 4: Backend Service
- Method: [service method]
- Input: [what it receives]
- Output: [what it returns]
- Business logic: [transformation applied]
- Verdict: [Data is correct/incorrect at this layer]

### Layer 5: Database/External
- Query/Call: [what was executed]
- Result: [what was returned]
- Verdict: [Data is correct/incorrect at this layer]

### Bug Location
The data becomes incorrect between Layer [X] and Layer [Y].
Root cause: [specific code that transforms data incorrectly]
```

## COMMON CROSS-SERVICE ISSUES

### API Contract Mismatch
Frontend expects `{ userName: string }` but API returns `{ user_name: string }`
- Check: DTO/response serialization, case transformation middleware

### Stale Cache
Frontend caches old data, API returns new data but it's not reflected
- Check: Cache invalidation, ETag/Last-Modified headers, Redux cache

### Auth Token Issues
Token expired between frontend and API call
- Check: Token refresh flow, interceptor handling, race conditions in refresh

### Pagination/Filtering Discrepancy
Frontend sends page=2 but gets wrong data
- Check: Offset calculation, 0-indexed vs 1-indexed, sort order consistency

### Timezone Issues
Dates appear shifted by hours
- Check: UTC storage, timezone conversion in serialization, frontend display formatting
