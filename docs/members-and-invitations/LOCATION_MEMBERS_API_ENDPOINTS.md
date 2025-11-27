# Location Members API Endpoints - Complete Reference

## Quick Reference Table

| Endpoint | Method | Auth | Purpose |
|----------|--------|------|---------|
| `/members/invitations` | POST | ✅ | Send invitation |
| `/members/invitations/{token}` | GET | ❌ | Get invitation details (public) |
| `/members/invitations/respond` | POST | ✅ | Accept/decline invitation |
| `/members` | POST | ✅ | Create location member |
| `/members` | GET | ✅ | List members (with filters) |
| `/members/{id}` | GET | ✅ | Get member details |
| `/members/{id}` | POST | ✅ | Update member |
| `/members/{id}` | DELETE | ✅ | Delete member |
| `/members/{id}/revoke` | POST | ✅ | Revoke member access |

---

## Detailed Endpoints

### 1. Send Invitation

**Endpoint**: `POST /members/invitations`

**Authentication**: Required (Bearer token)

**Purpose**: Create an invitation and send via SMS/WhatsApp to bring a new member into a location

**Request Headers**:
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body**:
```json
{
  "phone_number": "+573145938499",
  "receptor_name": "Juan Pérez",
  "organization_id": "550e8400-e29b-41d4-a716-446655440000",
  "location_id": "650e8400-e29b-41d4-a716-446655440001",
  "role": "member",
  "send_by": "sms"
}
```

**Request Field Descriptions**:

| Field | Type | Required | Description | Constraints |
|-------|------|----------|-------------|-------------|
| `phone_number` | string | Yes | Phone number to send invitation to | Valid phone format, e.g., +573145938499 |
| `receptor_name` | string | Yes | Name of invitation recipient | Used in SMS/WhatsApp message |
| `organization_id` | UUID | Yes | Organization profile ID | Must exist in database |
| `location_id` | UUID | No* | Physical location ID | Required for member/manager, optional for super-admin |
| `role` | enum | Yes | Role for the member | member, manager, or super-admin |
| `send_by` | enum | Yes | Notification channel | sms or whatsapp |

**Validation Rules**:
- If `role` is "member" or "manager": `location_id` must be provided
- If `role` is "super-admin": `location_id` is optional
- Organization with `organization_id` must exist
- Location with `location_id` must exist (if provided)
- Phone number must be in valid format

**Success Response** (200 OK):
```json
{
  "ok": true,
  "data": {
    "id": "mem-550e8400-e29b-41d4-a716-446655440000",
    "organization": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Beauty Studio XYZ",
      "description": "Premium beauty salon"
    },
    "location": {
      "id": "650e8400-e29b-41d4-a716-446655440001",
      "name": "Downtown Location",
      "address": "Calle 5 #10-20"
    },
    "artist": null,
    "member": null,
    "role": "member",
    "location_member_settings": null,
    "accepted_at": null,
    "declined_at": null,
    "invitation_phone_number": "+573145938499",
    "invitation_receptor_name": "Juan Pérez",
    "invitation_token": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6",
    "token_expiration_date": "2025-10-29T10:30:45.123Z",
    "is_active": true
  },
  "error": null
}
```

**Error Responses**:
```json
// Organization not found
{
  "ok": false,
  "data": null,
  "error": "Organization not found"
}

// Location not found
{
  "ok": false,
  "data": null,
  "error": "Location not found"
}

// Invalid role/location combination
{
  "ok": false,
  "data": null,
  "error": "location_id is required for member/manager roles"
}
```

**Message Template**:
The SMS/WhatsApp message follows this pattern:
```
Hi {receptor_name}, you are invited to join {organization_name} at {location_name} as {role}. Open: {invitation_link}
```

Example:
```
Hi Juan Pérez, you are invited to join Beauty Studio XYZ at Downtown Location as member. Open: https://aesthetic-artists.com/invitations?token=a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

---

### 2. Get Invitation Details

**Endpoint**: `GET /members/invitations/{token}`

**Authentication**: Not required (public)

**Purpose**: Retrieve invitation details without authentication, used by frontend to display invitation information before user logs in

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| `token` | string | The invitation token from the SMS/WhatsApp link |

**Query Parameters**: None

**Success Response** (200 OK):
```json
{
  "ok": true,
  "data": {
    "phone_number": "+573145938499",
    "receptor_name": "Juan Pérez",
    "organization": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Beauty Studio XYZ",
      "description": "Premium beauty salon",
      "logo": "https://cdn.example.com/logo.png"
    },
    "location": {
      "id": "650e8400-e29b-41d4-a716-446655440001",
      "name": "Downtown Location",
      "address": "Calle 5 #10-20",
      "city": "Medellín",
      "country": "Colombia"
    },
    "role": "member"
  },
  "error": null
}
```

**Error Responses**:
```json
// Token not found
{
  "ok": false,
  "data": null,
  "error": "Invitation not found"
}

// Token already processed
{
  "ok": false,
  "data": null,
  "error": "Invitation not available"
}

// Token expired
{
  "ok": false,
  "data": null,
  "error": "Invitation token expired"
}
```

**Use Case**:
1. User receives SMS with link: `https://app.com/invite?token=abc123`
2. Frontend calls `GET /members/invitations/abc123`
3. Display invitation details (organization, location, role)
4. User logs in or creates account
5. User proceeds to accept/decline

---

### 3. Respond to Invitation

**Endpoint**: `POST /members/invitations/respond`

**Authentication**: Required (Bearer token)

**Purpose**: Accept or decline a location member invitation

**Request Headers**:
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body**:
```json
{
  "token": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6",
  "action": "accept"
}
```

**Request Field Descriptions**:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `token` | string | Yes | The invitation token |
| `action` | enum | Yes | "accept" or "decline" |

**Accept Flow** - When `action === "accept"`:

1. Validates token exists and is pending
2. Fetches authenticated user
3. Validates user's phone matches invitation phone (security check)
4. For member/manager roles: validates location is assigned
5. Creates active membership: sets `member = user`, `accepted_at = now()`
6. Clears invitation fields: `invitation_token = null`, `token_expiration_date = null`

**Success Response** (200 OK):
```json
{
  "ok": true,
  "data": {
    "id": "mem-550e8400-e29b-41d4-a716-446655440000",
    "organization": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Beauty Studio XYZ"
    },
    "location": {
      "id": "650e8400-e29b-41d4-a716-446655440001",
      "name": "Downtown Location"
    },
    "artist": null,
    "member": {
      "id": "user-550e8400-e29b-41d4-a716-446655440002",
      "name": "Juan Pérez",
      "email": "juan@example.com",
      "phone_number": "+573145938499"
    },
    "role": "member",
    "accepted_at": "2025-10-22T15:30:45.123Z",
    "is_active": true,
    "invitation_token": null,
    "token_expiration_date": null
  },
  "error": null
}
```

**Decline Flow** - When `action === "decline"`:

1. Validates token exists and is pending
2. Sets `declined_at = now()`
3. Sets `is_active = false`
4. Does not create membership record

**Success Response** (200 OK):
```json
{
  "ok": true,
  "data": {
    "declined": true,
    "declined_at": "2025-10-22T15:30:45.123Z"
  },
  "error": null
}
```

**Error Responses**:
```json
// Token not found
{
  "ok": false,
  "data": null,
  "error": "Invitation not found"
}

// Phone number mismatch (critical security check)
{
  "ok": false,
  "data": null,
  "error": "Phone number mismatch for this invitation"
}

// User not found
{
  "ok": false,
  "data": null,
  "error": "User not found"
}

// User has no phone number
{
  "ok": false,
  "data": null,
  "error": "User does not have a phone number"
}

// Token expired
{
  "ok": false,
  "data": null,
  "error": "Invitation token expired"
}

// Already processed
{
  "ok": false,
  "data": null,
  "error": "Invitation already processed"
}
```

**Critical Security Note**:
The phone number validation (`user.phone_number === invitation_phone_number`) is the security mechanism that ensures only the intended recipient can accept the invitation. This prevents unauthorized users from accepting invitations meant for others.

---

### 4. Create Location Member

**Endpoint**: `POST /members`

**Authentication**: Required (Bearer token)

**Purpose**: Directly create a location member without invitation flow (administrative)

**Request Headers**:
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body**:
```json
{
  "organization_id": "550e8400-e29b-41d4-a716-446655440000",
  "location_id": "650e8400-e29b-41d4-a716-446655440001",
  "member_id": "user-550e8400-e29b-41d4-a716-446655440002",
  "artist_id": "artist-550e8400-e29b-41d4-a716-446655440003",
  "role": "manager"
}
```

**Request Field Descriptions**:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `organization_id` | UUID | Yes | Organization profile ID |
| `location_id` | UUID | Yes | Physical location ID |
| `member_id` | UUID | Yes | User ID to be added |
| `artist_id` | UUID | No | Artist profile ID (optional) |
| `role` | enum | Yes | member, manager, or super-admin |

**Success Response** (201 Created):
```json
{
  "ok": true,
  "data": {
    "id": "mem-550e8400-e29b-41d4-a716-446655440004",
    "organization": { /* ... */ },
    "location": { /* ... */ },
    "member": { /* ... */ },
    "artist": null,
    "role": "manager",
    "accepted_at": "2025-10-22T15:30:45.123Z",
    "is_active": true,
    "invitation_token": null
  },
  "error": null
}
```

**Differences from Invitation Flow**:
- ✅ No phone number validation required
- ✅ No SMS/WhatsApp notification
- ✅ Member immediately active
- ✅ No token generation
- ✅ Direct user assignment

---

### 5. Get All Location Members

**Endpoint**: `GET /members`

**Authentication**: Required (Bearer token)

**Purpose**: List all location members with optional filtering

**Query Parameters** (all optional):

| Parameter | Type | Description |
|-----------|------|-------------|
| `organization_id` | UUID | Filter by organization |
| `location_id` | UUID | Filter by location |
| `member_id` | UUID | Filter by member user |
| `artist_id` | UUID | Filter by artist profile |

**Example Requests**:
```
GET /members
GET /members?organization_id=org-123
GET /members?organization_id=org-123&location_id=loc-456
GET /members?member_id=user-123
GET /members?artist_id=artist-123
```

**Success Response** (200 OK):
```json
{
  "ok": true,
  "data": [
    {
      "id": "mem-001",
      "organization": { "id": "org-123", "name": "Beauty Studio" },
      "location": { "id": "loc-456", "name": "Downtown" },
      "member": { "id": "user-789", "name": "Juan Pérez" },
      "role": "member",
      "is_active": true,
      "accepted_at": "2025-10-22T10:00:00Z"
    },
    {
      "id": "mem-002",
      "organization": { "id": "org-123", "name": "Beauty Studio" },
      "location": { "id": "loc-456", "name": "Downtown" },
      "member": { "id": "user-790", "name": "Maria García" },
      "role": "manager",
      "is_active": true,
      "accepted_at": "2025-10-21T14:30:00Z"
    }
  ],
  "error": null
}
```

**Error Response**:
```json
{
  "ok": false,
  "data": null,
  "error": "Unauthorized"
}
```

---

### 6. Get Location Member by ID

**Endpoint**: `GET /members/{id}`

**Authentication**: Required (Bearer token)

**Purpose**: Retrieve details of a specific location member

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Location member ID |

**Success Response** (200 OK):
```json
{
  "ok": true,
  "data": {
    "id": "mem-550e8400-e29b-41d4-a716-446655440000",
    "organization": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Beauty Studio XYZ"
    },
    "location": {
      "id": "650e8400-e29b-41d4-a716-446655440001",
      "name": "Downtown Location"
    },
    "member": {
      "id": "user-550e8400-e29b-41d4-a716-446655440002",
      "name": "Juan Pérez"
    },
    "artist": null,
    "role": "member",
    "location_member_settings": {
      "can_manage_members": false,
      "can_edit_location": false
    },
    "accepted_at": "2025-10-22T10:00:00Z",
    "is_active": true
  },
  "error": null
}
```

**Error Response**:
```json
{
  "ok": false,
  "data": null,
  "error": "Location member not found"
}
```

---

### 7. Update Location Member

**Endpoint**: `POST /members/{id}`

**Authentication**: Required (Bearer token)

**Purpose**: Update location member information

**Request Body** (all fields optional):
```json
{
  "role": "manager",
  "location_member_settings": {
    "can_manage_members": true,
    "can_edit_location": false,
    "custom_field": "custom_value"
  }
}
```

**Updatable Fields**:
- `role`: Change member role (member, manager, super-admin)
- `location_member_settings`: JSON settings object

**Success Response** (200 OK):
```json
{
  "ok": true,
  "data": {
    "id": "mem-550e8400-e29b-41d4-a716-446655440000",
    "role": "manager",
    "location_member_settings": {
      "can_manage_members": true,
      "can_edit_location": false
    },
    "is_active": true
  },
  "error": null
}
```

**Error Response**:
```json
{
  "ok": false,
  "data": null,
  "error": "Location member not found"
}
```

---

### 8. Delete Location Member

**Endpoint**: `DELETE /members/{id}`

**Authentication**: Required (Bearer token)

**Purpose**: Permanently remove a location member (hard delete)

**Path Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Location member ID |

**Success Response** (200 OK):
```json
{
  "ok": true,
  "data": {
    "message": "Location member deleted successfully"
  },
  "error": null
}
```

**Error Response**:
```json
{
  "ok": false,
  "data": null,
  "error": "Location member not found"
}
```

**⚠️ Warning**: This operation is permanent. Consider using the `revoke` endpoint instead for reversible deactivation.

---

### 9. Revoke Member from Location

**Endpoint**: `POST /members/{id}/revoke`

**Authentication**: Required (Bearer token)

**Purpose**: Deactivate member access without permanent deletion (soft delete, reversible)

**Request Body**:
```json
{
  "organization_id": "550e8400-e29b-41d4-a716-446655440000",
  "location_id": "650e8400-e29b-41d4-a716-446655440001"
}
```

**Request Field Descriptions**:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `organization_id` | UUID | Yes | For verification - member's organization |
| `location_id` | UUID | Yes | For verification - member's location |

**What Happens**:
1. Verifies member exists
2. Validates member's organization matches provided `organization_id`
3. Validates member's location matches provided `location_id`
4. Sets `is_active = false` (soft delete)
5. Member no longer appears in Get Auth Info

**Success Response** (200 OK):
```json
{
  "ok": true,
  "data": {
    "message": "Member revoked successfully",
    "member": {
      "id": "mem-550e8400-e29b-41d4-a716-446655440000",
      "organization": {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "name": "Beauty Studio XYZ"
      },
      "location": {
        "id": "650e8400-e29b-41d4-a716-446655440001",
        "name": "Downtown Location"
      },
      "is_active": false,
      "role": "member"
    }
  },
  "error": null
}
```

**Error Responses**:
```json
// Member not found
{
  "ok": false,
  "data": null,
  "error": "Location member not found"
}

// Organization mismatch
{
  "ok": false,
  "data": null,
  "error": "Location member does not belong to this organization"
}

// Location mismatch
{
  "ok": false,
  "data": null,
  "error": "Location member does not belong to this location"
}
```

**Revoke vs Delete**:

| Aspect | Revoke | Delete |
|--------|--------|--------|
| Database | Soft delete (is_active=false) | Hard delete (removed) |
| Reversible | Yes (set is_active=true) | No |
| Audit Trail | Record remains | Record gone |
| Query Filtering | Excluded by is_active=false | Not found |
| Use Case | Temporary deactivation | Permanent removal |

---

## Common Workflows

### Workflow 1: Invite New Team Member

```
1. Admin: POST /members/invitations
   ↓
2. System: Sends SMS/WhatsApp
   ↓
3. User: Clicks link, views invitation details (GET /members/invitations/{token})
   ↓
4. User: Logs in to app
   ↓
5. User: POST /members/invitations/respond with action: "accept"
   ↓
6. System: Creates active membership
   ↓
7. User: Membership appears in GET /auth/user-info
```

### Workflow 2: Temporarily Revoke Access

```
1. Admin: POST /members/{id}/revoke
   ↓
2. System: Sets is_active=false
   ↓
3. User: Membership removed from GET /auth/user-info
   ↓
(Later)
4. Admin: POST /members/{id} with is_active: true
   ↓
5. System: Reactivates membership
   ↓
6. User: Membership restored in GET /auth/user-info
```

### Workflow 3: Administratively Add Member

```
1. Admin: POST /members
   ↓
2. System: Creates active membership immediately
   ↓
3. User: Membership appears in GET /auth/user-info
   ↓
4. No email/SMS sent (direct creation)
```

---

## Authentication & Authorization

All endpoints except `GET /members/invitations/{token}` require JWT authentication:

**Required Header**:
```
Authorization: Bearer <jwt_token>
```

**Token obtained from**:
- `POST /auth/login` (email/password)
- `GET /auth/facebook` (OAuth)
- `GET /auth/facebook/redirect` (OAuth callback)

---

## Rate Limiting & Performance

- No explicit rate limiting configured
- Filtering queries are indexed on: `organization_id`, `location_id`, `member_id`, `artist_id`
- Token generation is O(1) operation
- Large member lists recommend pagination (not yet implemented)

---

## Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success (GET, POST updates) |
| 201 | Created (POST new) |
| 400 | Bad request (validation error) |
| 401 | Unauthorized (missing token) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not found (resource doesn't exist) |
| 500 | Server error |

