# Location Members and Invitations - Complete Documentation

## Overview

This document describes the complete flow for managing location members and invitations within the Aesthetic Artists system. Location members represent users who are associated with specific locations and organizations, with defined roles and permissions.

The system supports two pathways for becoming a location member:
1. **Invitation Flow**: Phone-based invitation with SMS/WhatsApp notification
2. **Direct Creation**: Administrative creation of location members

## Table of Contents

1. [Core Concepts](#core-concepts)
2. [Data Structure](#data-structure)
3. [Invitation Flow](#invitation-flow)
4. [Member Management](#member-management)
5. [Role System](#role-system)
6. [Integration with Get Auth Info](#integration-with-get-auth-info)
7. [API Endpoints](#api-endpoints)
8. [Business Rules](#business-rules)
9. [Examples](#examples)

---

## Core Concepts

### Location Member
A **Location Member** represents the relationship between:
- A **User** (the member)
- A **Location** (physical place)
- An **Organization** (profile/business)
- An optional **Artist** (artist profile associated with the membership)
- A **Role** (member, manager, or super-admin)

### Membership Lifecycle

```
Invitation Created → Token Generated → Sent via SMS/WhatsApp
                            ↓
                User Clicks Link / Accepts
                            ↓
        Phone Number Validated → Membership Activated
                            ↓
              Member Appears in Get Auth Info
```

### Membership States

1. **Pending (Invitation)**: `invitation_token` is set, `accepted_at` is null, `declined_at` is null
2. **Active (Accepted)**: `invitation_token` is null, `accepted_at` is set, `is_active` is true
3. **Declined**: `declined_at` is set, `is_active` is false
4. **Revoked**: `is_active` is false (marks as inactive without deletion)
5. **Deleted**: Permanently removed from database

---

## Data Structure

### MemberEntity

```typescript
{
  id: string;                           // UUID primary key
  organization: ProfileEntity;          // Organization/business profile
  location?: LocationEntity;            // Physical location (optional for SuperAdmin)
  artist?: ProfileEntity;               // Artist profile (optional)
  member?: UserEntity;                  // User (null until invitation accepted)
  role: MemberRole;             // member | manager | super-admin
  
  // Invitation fields (populated during invitation)
  invitation_phone_number?: string;     // Phone number invitation sent to
  invitation_receptor_name?: string;    // Name of invitation recipient
  invitation_token?: string;            // Unique token for acceptance link
  token_expiration_date?: Date;         // When token expires (default: 7 days)
  
  // Lifecycle timestamps
  accepted_at?: Date;                   // When invitation was accepted
  declined_at?: Date;                   // When invitation was declined
  
  // Settings and status
  location_member_settings?: {          // JSON settings for member
    can_manage_members?: boolean;
    can_edit_location?: boolean;
    [key: string]: any;
  };
  is_active: boolean;                   // Soft delete flag
}
```

---

## Invitation Flow

### Step 1: Create Invitation

**Endpoint**: `POST /members/invitations`

**Request Body**:
```json
{
  "phone_number": "+573145938499",
  "receptor_name": "Juan Pérez",
  "organization_id": "org-uuid-here",
  "location_id": "location-uuid-here",  // Required for Member/Manager, optional for SuperAdmin
  "role": "member",                     // member | manager | super-admin
  "send_by": "sms"                      // sms | whatsapp
}
```

**What Happens**:
1. Validates the role and location requirements:
   - **SuperAdmin**: Can work across multiple locations, `location_id` is optional
   - **Manager/Member**: Must be assigned to a specific location
2. Generates a unique 32-character hex token
3. Sets token expiration to 7 days from now
4. Creates a `MemberEntity` record with:
   - `is_active = true`
   - `invitation_token` = generated token
   - `member = null` (not yet accepted)
5. Sends invitation message via SMS or WhatsApp:
   ```
   Hi {receptor_name}, you are invited to join {organization_name} 
   at {location_name} as {role}. 
   Open: https://aesthetic-artists.com/invitations?token={token}
   ```

**Response**:
```json
{
  "ok": true,
  "data": {
    "id": "member-uuid",
    "organization": { /* organization data */ },
    "location": { /* location data */ },
    "role": "member",
    "invitation_phone_number": "+573145938499",
    "invitation_receptor_name": "Juan Pérez",
    "invitation_token": "abc123def456...",
    "token_expiration_date": "2025-10-29T10:30:45.123Z",
    "is_active": true
  },
  "error": null
}
```

---

### Step 2: Get Invitation Details (No Auth Required)

**Endpoint**: `GET /members/invitations/{token}`

**Purpose**: Frontend can display invitation details before user logs in

**Response**:
```json
{
  "ok": true,
  "data": {
    "phone_number": "+573145938499",
    "receptor_name": "Juan Pérez",
    "organization": {
      "id": "org-uuid",
      "name": "Beauty Studio XYZ",
      "description": "Premium beauty salon"
    },
    "location": {
      "id": "loc-uuid",
      "name": "Downtown Location",
      "address": "Calle 5 #10-20"
    },
    "role": "member"
  },
  "error": null
}
```

**Validations**:
- Token must exist and be active
- Token must not already be processed (no `accepted_at` or `declined_at`)
- Token must not be expired

---

### Step 3: Accept or Decline Invitation

**Endpoint**: `POST /members/invitations/respond`

**Request Body**:
```json
{
  "token": "abc123def456...",
  "action": "accept"  // accept | decline
}
```

**Accept Action** (when `action === "accept"`):
1. Validates invitation exists and is pending
2. Fetches the authenticated user
3. **Critical Validation**: User's phone number must match the phone number in the invitation
   - This ensures only the intended recipient can accept
4. For Member/Manager roles: Validates that location is assigned
5. Finalizes the membership:
   - Sets `member = authenticated_user`
   - Sets `accepted_at = now()`
   - Clears `invitation_token` and `token_expiration_date`
   - Keeps `is_active = true`
6. Returns the updated membership record

**Decline Action** (when `action === "decline"`):
1. Validates invitation exists and is pending
2. Sets `declined_at = now()`
3. Sets `is_active = false`
4. Returns confirmation without creating a membership

**Response** (Accept):
```json
{
  "ok": true,
  "data": {
    "id": "member-uuid",
    "member": { /* user data */ },
    "organization": { /* organization */ },
    "location": { /* location */ },
    "artist": { /* artist profile if set */ },
    "role": "member",
    "accepted_at": "2025-10-22T15:30:45.123Z",
    "is_active": true
  },
  "error": null
}
```

---

## Member Management

### Create Location Member (Direct)

**Endpoint**: `POST /members`

**Purpose**: Administratively create a location member without invitation flow

**Request Body**:
```json
{
  "organization_id": "org-uuid",
  "location_id": "location-uuid",
  "member_id": "user-uuid",
  "artist_id": "artist-profile-uuid",  // optional
  "role": "manager"
}
```

**Differences from Invitation Flow**:
- No phone number validation
- User is immediately set as `member`
- No invitation token generated
- `accepted_at` is set to current time
- No SMS/WhatsApp notification sent

---

### Get All Location Members (with Filtering)

**Endpoint**: `GET /members?organization_id=X&location_id=Y&member_id=Z&artist_id=W`

**Query Parameters** (all optional):
- `organization_id`: Filter by organization
- `location_id`: Filter by location
- `member_id`: Filter by member user
- `artist_id`: Filter by artist profile

**Response**:
```json
{
  "ok": true,
  "data": [
    {
      "id": "member-uuid-1",
      "organization": { /* ... */ },
      "location": { /* ... */ },
      "member": { /* ... */ },
      "role": "member",
      "is_active": true,
      "accepted_at": "2025-10-22T10:00:00.000Z"
    },
    {
      "id": "member-uuid-2",
      "organization": { /* ... */ },
      "location": { /* ... */ },
      "member": { /* ... */ },
      "role": "manager",
      "is_active": true,
      "accepted_at": "2025-10-21T14:30:00.000Z"
    }
  ],
  "error": null
}
```

---

### Get Location Member by ID

**Endpoint**: `GET /members/{id}`

**Response**: Single location member object with all relations loaded

---

### Update Location Member

**Endpoint**: `POST /members/{id}`

**Request Body** (all fields optional):
```json
{
  "role": "manager",
  "location_member_settings": {
    "can_manage_members": true,
    "can_edit_location": false
  }
}
```

---

### Revoke Member from Location

**Endpoint**: `POST /members/{id}/revoke`

**Purpose**: Deactivate a member without permanent deletion (reversible)

**Request Body**:
```json
{
  "organization_id": "org-uuid",
  "location_id": "location-uuid"
}
```

**What Happens**:
1. Validates member exists
2. Verifies member belongs to the specified organization
3. Verifies member belongs to the specified location
4. Sets `is_active = false`
5. Returns the revoked member record

**Key Difference from Delete**:
- `revoke`: Sets `is_active = false` (soft delete, reversible)
- `delete`: Permanently removes from database (hard delete, non-reversible)

**Response**:
```json
{
  "ok": true,
  "data": {
    "message": "Member revoked successfully",
    "member": {
      "id": "member-uuid",
      "is_active": false,
      "organization": { /* ... */ },
      "location": { /* ... */ },
      "role": "member"
    }
  },
  "error": null
}
```

---

### Delete Location Member

**Endpoint**: `DELETE /members/{id}`

**Purpose**: Permanently remove member record from database

**Warning**: This operation is non-reversible. Consider using `revoke` instead for soft deletion.

---

## Role System

The system supports three distinct roles with different levels of access:

### 1. Member
- **Location Requirement**: Must be assigned to a specific location
- **Permissions**: Can work at their assigned location
- **Use Cases**: Individual stylists, makeup artists, or service providers
- **Location Visibility**: See only their assigned location

### 2. Manager
- **Location Requirement**: Must be assigned to a specific location
- **Permissions**: Can manage members and settings at their location
- **Use Cases**: Location managers, salon managers
- **Location Visibility**: See only their assigned location
- **Additional Capabilities**: Can manage other members, edit settings

### 3. SuperAdmin
- **Location Requirement**: Optional (can manage entire organization)
- **Permissions**: Access to all locations of the organization
- **Use Cases**: Business owners, organization administrators
- **Location Visibility**: See all locations of the organization (if `location_id` is null)
- **Additional Capabilities**: Full administrative access

### Role Assignment Logic

**During Invitation**:
```typescript
if (role === MemberRole.SuperAdmin) {
  // location_id is optional
  // SuperAdmin can be invited at organization level
} else {
  // location_id is required
  // Manager/Member must be assigned to a specific location
}
```

**During Acceptance**:
```typescript
if (invitation.role !== MemberRole.SuperAdmin && !invitation.location) {
  throw new Error('Location is required for member/manager roles');
}
```

---

## Integration with Get Auth Info

### How Location Members Appear in Get Auth Info Response

When the authenticated user calls `GET /auth/user-info`, the response includes active location memberships. The `MembersService` helps filter and structure this data.

### Filtering Rules Applied in Get Auth Info

The `users.service.ts` `findOneWithAuthInfo()` method applies these rules when loading location memberships:

**Rule 1: Only Active, Accepted Memberships**
```typescript
.leftJoinAndSelect(
  'user.locations_worked',
  'locations_worked',
  'locations_worked.is_active = true AND locations_worked.accepted_at IS NOT NULL'
)
```

This filters to include only:
- `is_active = true` (not revoked)
- `accepted_at IS NOT NULL` (invitation has been accepted)

**Excludes**:
- Pending invitations (no `accepted_at` yet)
- Declined invitations
- Revoked memberships

**Rule 2: Conditional Location Filtering**

Based on the user's role and location assignment:

```typescript
CASE WHEN 
  locations_worked.location_id IS NULL 
  AND locations_worked.role = 'super-admin' 
THEN 
  1=1  // Load ALL organization locations
ELSE 
  locations.id = locations_worked.location_id  // Load specific location
END
```

- **SuperAdmin without location_id**: Gets all organization locations
- **Member/Manager with location_id**: Gets only their assigned location

**Rule 3: Transformation to Flat Structure**

The nested structure is flattened so each entry represents membership at ONE specific location:

**Before Transformation**:
```json
{
  "locations_worked": [
    {
      "organization": {
        "id": "org-1",
        "name": "Beauty Studio XYZ",
        "locations": [
          { "id": "loc-1", "name": "Downtown" },
          { "id": "loc-2", "name": "Uptown" }
        ]
      },
      "artist": { "id": "artist-1" },
      "role": "super-admin"
    }
  ]
}
```

**After Transformation**:
```json
{
  "locations_worked": [
    {
      "organization": { "id": "org-1", "name": "Beauty Studio XYZ" },
      "location": { "id": "loc-1", "name": "Downtown" },
      "artist": { "id": "artist-1" },
      "role": "super-admin"
    },
    {
      "organization": { "id": "org-1", "name": "Beauty Studio XYZ" },
      "location": { "id": "loc-2", "name": "Uptown" },
      "artist": { "id": "artist-1" },
      "role": "super-admin"
    }
  ]
}
```

### Edge Case: Organizations with No Locations

If an organization has no physical locations defined yet:

```json
{
  "locations_worked": [
    {
      "organization": { "id": "org-1", "name": "Beauty Studio XYZ" },
      "location": null,  // No physical location yet
      "artist": { "id": "artist-1" },
      "role": "member"
    }
  ]
}
```

This allows users to maintain their membership even before locations are created.

---

## Business Rules

### Invitation Validation Rules

| Rule | Description | Error |
|------|-------------|-------|
| **Role/Location** | SuperAdmin optional location, Member/Manager require location | "location_id is required for member/manager roles" |
| **Organization Exists** | Organization profile must exist | "Organization not found" |
| **Location Exists** | If location_id provided, location must exist | "Location not found" |
| **Token Format** | Automatically generated as 32-char hex string | - |
| **Token Expiration** | Default 7 days from creation | Checked on retrieval |

### Acceptance Validation Rules

| Rule | Description | Error |
|------|-------------|-------|
| **Phone Match** | User's phone must match invitation phone | "Phone number mismatch for this invitation" |
| **User Exists** | User must be authenticated and exist | "User not found" |
| **User Has Phone** | User must have phone number | "User does not have a phone number" |
| **Token Not Expired** | Must check before accepting | "Invitation token expired" |
| **Not Processed** | Cannot accept already accepted/declined | "Invitation already processed" |
| **Role/Location** | Member/Manager roles require location | "Location is required for member/manager roles" |

### Membership Rules

| Rule | Description |
|------|-------------|
| **Unique per Location** | One active membership per user per location |
| **Role-Based Visibility** | Users see locations based on role |
| **Soft Delete on Revoke** | Revoke sets is_active=false, not hard delete |
| **Active Filter** | Get Auth Info only includes is_active=true |

---

## API Endpoints

### Location Member Invitations

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/members/invitations` | Yes | Send invitation |
| GET | `/members/invitations/{token}` | No | Get invitation details |
| POST | `/members/invitations/respond` | Yes | Accept/decline invitation |

### Location Members

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/members` | Yes | Create location member |
| GET | `/members` | Yes | Get all members (with filters) |
| GET | `/members/{id}` | Yes | Get member by ID |
| POST | `/members/{id}` | Yes | Update member |
| DELETE | `/members/{id}` | Yes | Delete member |
| POST | `/members/{id}/revoke` | Yes | Revoke member access |

---

## Examples

### Example 1: Full Invitation Flow

```
1. Admin sends invitation:
   POST /members/invitations
   {
     "phone_number": "+573145938499",
     "receptor_name": "Maria García",
     "organization_id": "org-abc123",
     "location_id": "loc-xyz789",
     "role": "member",
     "send_by": "sms"
   }

   Response: 
   {
     "id": "inv-001",
     "invitation_token": "a1b2c3d4e5f6...",
     "token_expiration_date": "2025-10-29"
   }

2. SMS sent to +573145938499:
   "Hi Maria García, you are invited to join Beauty Studio XYZ 
    at Downtown Location as member. 
    Open: https://aesthetic-artists.com/invitations?token=a1b2c3d4e5f6..."

3. User receives SMS, clicks link, logs in
   (Frontend gets token from URL)

4. User accepts invitation:
   POST /members/invitations/respond
   {
     "token": "a1b2c3d4e5f6...",
     "action": "accept"
   }

   Validation: User's phone_number === "+573145938499" ✓

   Response:
   {
     "id": "inv-001",
     "member": { "id": "user-maria", "phone_number": "+573145938499" },
     "accepted_at": "2025-10-22T15:30:00Z",
     "is_active": true
   }

5. User calls GET /auth/user-info:
   Response includes in locations_worked:
   {
     "organization": { "id": "org-abc123", "name": "Beauty Studio XYZ" },
     "location": { "id": "loc-xyz789", "name": "Downtown Location" },
     "role": "member",
     "is_active": true
   }
```

### Example 2: SuperAdmin with Multiple Locations

```
1. SuperAdmin invited to organization (no specific location):
   POST /members/invitations
   {
     "phone_number": "+573145938499",
     "receptor_name": "Juan Owner",
     "organization_id": "org-abc123",
     "location_id": null,  // Not specified
     "role": "super-admin",
     "send_by": "whatsapp"
   }

2. After acceptance, GET /auth/user-info returns:
   {
     "locations_worked": [
       {
         "organization": { "id": "org-abc123", "name": "Beauty Studio XYZ" },
         "location": { "id": "loc-1", "name": "Downtown" },
         "role": "super-admin"
       },
       {
         "organization": { "id": "org-abc123", "name": "Beauty Studio XYZ" },
         "location": { "id": "loc-2", "name": "Uptown" },
         "role": "super-admin"
       },
       {
         "organization": { "id": "org-abc123", "name": "Beauty Studio XYZ" },
         "location": { "id": "loc-3", "name": "Airport Mall" },
         "role": "super-admin"
       }
     ]
   }

   Note: Frontend shows 3 entries, one per location.
         SuperAdmin can manage all locations.
```

### Example 3: Revoking a Member

```
1. Admin revokes a member's access:
   POST /members/rev-member-001/revoke
   {
     "organization_id": "org-abc123",
     "location_id": "loc-xyz789"
   }

   Response: Member marked as is_active=false

2. Next time user calls GET /auth/user-info:
   That location membership is NOT included
   (because is_active=false is filtered out)

3. Admin can restore by updating member:
   POST /members/rev-member-001
   {
     "is_active": true  // Reactivate
   }

   Result: User's membership is restored
```

---

## Summary

The location members and invitations system provides:

✅ **Secure Invitation Flow**: Phone number validation ensures only intended recipients can accept  
✅ **Flexible Roles**: Member, Manager, SuperAdmin with different access levels  
✅ **Non-Destructive Revocation**: Revoke keeps record for audit, delete is permanent  
✅ **Multi-Channel Notifications**: SMS and WhatsApp support  
✅ **Integration with Auth**: Seamlessly integrated into Get Auth Info flow  
✅ **Token Expiration**: 7-day default, prevents stale invitations  
✅ **Dual Pathways**: Both invitation-based and direct creation  
✅ **Comprehensive Filtering**: Get Auth Info shows only relevant memberships  
