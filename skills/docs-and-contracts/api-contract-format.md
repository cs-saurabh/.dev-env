# Skill: API Contract Documentation Format

## PURPOSE
Guide the docs-and-contracts agent to produce clear, complete, and consistent API documentation.

## API CONTRACT STRUCTURE

### Per-Endpoint Documentation
```markdown
## [METHOD] /api/v1/resource

**Description:** [What this endpoint does]
**Authentication:** Required / Optional / None
**Authorization:** [Required roles/permissions]

### Request

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| id   | string (UUID) | Yes | Resource identifier |

**Query Parameters:**
| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| page | number | No | 1 | Page number |
| limit | number | No | 20 | Items per page (max 100) |
| sort | string | No | "createdAt" | Sort field |
| order | "asc" \| "desc" | No | "desc" | Sort direction |

**Request Body:**
```json
{
  "name": "string (required, 1-255 chars)",
  "description": "string (optional)",
  "tags": ["string"] // optional, default: []
}
```

### Response

**200 OK:**
```json
{
  "data": {
    "id": "uuid",
    "name": "string",
    "description": "string | null",
    "tags": ["string"],
    "createdAt": "ISO 8601 datetime",
    "updatedAt": "ISO 8601 datetime"
  }
}
```

**Error Responses:**
| Status | Description | When |
|--------|-------------|------|
| 400 | Bad Request | Validation failure |
| 401 | Unauthorized | Missing or invalid token |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate resource |
| 422 | Unprocessable | Valid format but invalid content |
| 500 | Server Error | Unexpected failure |

**Error Response Shape:**
```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "errors": [
    { "field": "name", "message": "Name is required" }
  ]
}
```
```

## DOCUMENTATION STANDARDS

### Completeness Checklist
For every endpoint, document:
- [ ] HTTP method and full URL path
- [ ] Description of what it does
- [ ] Authentication and authorization requirements
- [ ] All path, query, and body parameters with types
- [ ] Required vs optional fields with defaults
- [ ] Success response with example
- [ ] All error responses with conditions
- [ ] Rate limits (if applicable)
- [ ] Pagination format (if applicable)

### Naming Conventions
- Use consistent casing in documentation (match the API's actual casing)
- Use descriptive field names in examples (not `foo`, `bar`)
- Mark nullable fields explicitly (`string | null`)
- Specify format for special types (`ISO 8601 datetime`, `UUID`, `email`)

### Versioning
- Note API version in the path prefix (`/api/v1/`)
- Document breaking changes when version changes
- Mark deprecated endpoints clearly with migration guidance
