# Skill: Log and Error Analysis

## PURPOSE
Guide the debugging agent to efficiently read and interpret error logs, stack traces, and monitoring data to identify root causes.

## STACK TRACE READING

### JavaScript/TypeScript Stack Traces
Read from TOP to BOTTOM -- the top frame is where the error was thrown:
```
Error: Cannot read property 'name' of undefined
    at UserCard (src/components/UserCard.tsx:15:23)      <- ERROR HERE
    at renderWithHooks (react-dom.development.js:...)     <- React internals (skip)
    at mountIndeterminateComponent (...)                   <- React internals (skip)
```
- Focus on YOUR code frames (skip framework/library frames)
- The file and line number tell you exactly where to look
- The error message tells you WHAT went wrong

### Python Stack Traces
Read from BOTTOM to TOP -- the bottom frame is where the error was raised:
```
Traceback (most recent call last):
  File "main.py", line 42, in process_data         <- CALL CHAIN START
  File "services/transform.py", line 87, in transform  <- INTERMEDIATE
  File "utils/parser.py", line 15, in parse_date   <- ERROR HERE
ValueError: time data '2024-13-01' does not match format '%Y-%m-%d'
```

### NestJS Error Responses
```json
{
  "statusCode": 500,
  "message": "Internal server error",
  "error": "Internal Server Error"
}
```
The real error is in the server logs, not the response. Look for:
- The exception class and message
- The stack trace in server console/log output
- The request that triggered it (method, path, body)

## LOG ANALYSIS TECHNIQUES

### Keyword Scanning
Search for these patterns in order of severity:
1. `Error`, `Exception`, `FATAL`, `CRITICAL`
2. `Warning`, `WARN`, `deprecated`
3. `timeout`, `refused`, `unreachable`, `ECONNREFUSED`
4. `null`, `undefined`, `NaN`, `Invalid`
5. `401`, `403`, `404`, `500`, `502`, `503`

### Timeline Reconstruction
When investigating intermittent issues:
1. Find the timestamp of the failure
2. Look at logs 30 seconds before and after
3. Identify what changed: new deployment? Traffic spike? External service issue?
4. Correlate across services: did the API error match a DB timeout?

### Pattern Recognition
- Same error repeating at intervals -> likely a cron job or retry loop
- Errors only during peak hours -> likely a resource/capacity issue
- Errors only for specific users/data -> likely a data quality issue
- Errors after deployment -> likely a code change regression

## COMMON ERROR PATTERNS

| Error | Likely Cause |
|---|---|
| `Cannot read property X of undefined` | Missing null check, API returned unexpected shape |
| `ECONNREFUSED` | Service is down or wrong port/host |
| `ETIMEOUT` | Service is slow or network issue |
| `401 Unauthorized` | Token expired or missing |
| `403 Forbidden` | User lacks permission |
| `422 Unprocessable Entity` | Validation failure on input |
| `ENOMEM` | Memory leak or insufficient resources |
| `SQLITE_BUSY` / deadlock | Concurrent database access issue |

## OUTPUT FORMAT

```
## Log Analysis: [Error/Issue]

### Error Summary
[Exact error message and where it occurs]

### Timeline
[When it started, frequency, pattern]

### Root Cause (from logs)
[What the logs tell us about why this is happening]

### Evidence
- Log entry at [timestamp]: [relevant log line]
- Stack trace points to: [file:line]
- Correlating event: [what happened around the same time]

### Recommended Investigation
[What the debugging agent should look at next in the code]
```
