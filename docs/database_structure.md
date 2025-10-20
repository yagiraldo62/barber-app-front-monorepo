# Database Structure Documentation

This document describes the database structure for the Aesthetic Artists platform using TypeORM entities.

## Base Entities

### BaseEntity
Common fields for all entities with timestamps:
- `created_at`: Timestamp when record was created
- `updated_at`: Timestamp when record was last updated  
- `deleted_at`: Timestamp for soft deletion (nullable)

### BaseUuidEntity
Extends BaseEntity with UUID primary key:
- `id`: UUID primary key

## Core Entities

### 1. Users (`users`)
Represents platform users who can book appointments and own profiles.

**Fields:**
- `id`: UUID (primary key)
- `name`: User's full name
- `email`: Unique email address
- `username`: Unique username
- `phone_number`: Phone number (unique, nullable)
- `phone_number_verification_code`: Verification code for phone (excluded from serialization)
- `phone_number_verified_at`: Timestamp when phone was verified (excluded from serialization)
- `photo_url`: Profile photo URL (nullable)
- `user_settings`: JSONB field for user settings
- `location`: Geographic point for user location (nullable)

**Relations:**
- `categories`: Many-to-many with Categories (user interests)
- `appointments`: One-to-many with Appointments (as client)
- `profiles`: One-to-many with Profiles (owned profiles)
- `profiles_interactions`: One-to-many with UserProfileInteractions
- `locations_worked`: One-to-many with LocationMembers (locations where user works)

### 2. Profiles (`profiles`)
Represents artist/organization profiles that provide services.

**Fields:**
- `id`: UUID (primary key)
- `name`: Unique profile name
- `title`: Profile's professional title
- `description`: Profile description (nullable)
- `photo_url`: Profile photo URL (nullable)
- `type`: Enum - 'artist' or 'organization'
- `profile_settings`: JSONB field for profile configuration settings

**Relations:**
- `owner`: Many-to-one with User (profile owner)
- `media`: One-to-many with ProfileMedia
- `posts`: One-to-many with ProfilePosts
- `categories`: Many-to-many with Categories
- `services`: One-to-many with ArtistServices
- `user_interactions`: One-to-many with UserProfileInteractions
- `locations`: One-to-many with Locations (organization locations)
- `members`: One-to-many with LocationMembers (organization members)
- `locations_worked`: One-to-many with LocationMembers (locations where profile works)
- `appointments`: One-to-many with Appointments

### 3. Categories (`categories`)
Hierarchical service categories.

**Fields:**
- `id`: UUID (primary key)
- `name`: Category name (unique within parent)
- `icon`: Icon identifier (nullable)
- `parent_id`: UUID of parent category (nullable)

**Relations:**
- `parent`: Many-to-one with Category (self-reference)
- `subcategories`: One-to-many with Categories (self-reference)
- `location_services`: One-to-many with LocationService (unified table accessed from artist-location-services context)
- `services_templates`: One-to-many with ServicesTemplates
- `template_items`: One-to-many with ServicesTemplateItems

**Constraints:**
- Unique constraint on `(name, parent_id)`

## Service & Template Entities

### 4. ServicesTemplate (`services_template`)
Service templates for categories to standardize service offerings.

**Fields:**
- `id`: UUID (primary key)
- `name`: Template name (unique within category)
- `category_id`: UUID of associated category (nullable)

**Relations:**
- `category`: Many-to-one with Category
- `items`: One-to-many with ServicesTemplateItems

**Constraints:**
- Unique constraint on `(name, category_id)`

### 5. ServicesTemplateItem (`services_template_item`)
Individual service items within service templates.

**Fields:**
- `id`: UUID (primary key)
- `name`: Service item name
- `duration`: Duration in minutes (default 30)
- `price`: Service price (default 15000)
- `subcategory_id`: UUID of subcategory (nullable)
- `services_template_id`: UUID of parent template (nullable)

**Relations:**
- `subcategory`: Many-to-one with Category
- `template`: Many-to-one with ServicesTemplate

**Constraints:**
- Unique constraint on `(services_template_id, subcategory_id, name)`

### 6. LocationService (`location_services`)
Unified location-specific service offerings table that serves both contexts.

**Fields:**
- `id`: UUID (primary key)
- `name`: Service name
- `description`: Service description (text)
- `duration`: Duration in minutes (default 30)
- `price`: Service price (default 15000)
- `is_active`: Active status (default true)
- `subcategory_id`: UUID of subcategory (nullable)
- `location_id`: UUID of location

**Relations:**
- `subcategory`: Many-to-one with Category
- `location`: Many-to-one with Location
- `appointments`: One-to-many with AppointmentServices (from services context)
- `artist_services`: One-to-many with ArtistServices (from artist-location-services context)

**Constraints:**
- Unique constraint on `(name, location_id)`
- Unique constraint on `(name, subcategory_id)`

**Note:** This table is accessed by two different entity classes:
- `LocationServiceEntity` from `src/contexts/services/entities/location-service.entity.ts`
- `LocationServiceEntity` from `src/contexts/artist-location-services/entities/location-service.entity.ts`

Both entities map to the same unified table which contains fields from both contexts.

### 7. ArtistService (`artist_services`)
Artist-specific service offerings linking profiles to location services.

**Fields:**
- `id`: UUID (primary key)
- `description`: Service description
- `duration`: Duration in minutes (default 30)
- `price`: Service price (default 15000)
- `artist_profile_id`: UUID of artist profile (nullable)
- `location_service_id`: UUID of location service

**Relations:**
- `artist_profile`: Many-to-one with Profile
- `location_service`: Many-to-one with LocationService (from artist-location-services context)
- `appointments`: One-to-many with AppointmentServices

**Constraints:**
- Unique constraint on `(artist_profile_id, location_service_id)`

## Location & Availability Entities

### 8. Locations (`locations`)
Physical locations where profiles provide services.

**Fields:**
- `id`: UUID (primary key)
- `name`: Location name
- `address`: Street address (nullable)
- `address2`: Additional address info (nullable)
- `country`: Country (default 'Colombia')
- `state`: State/Province (default 'Antioquia')
- `city`: City (default 'Medellin')
- `location`: Geographic point (nullable)
- `is_published`: Publication status (default false)
- `services_up`: Boolean - Services configuration status (default false) **[Also in location_settings]**
- `availability_up`: Boolean - Availability configuration status (default false) **[Also in location_settings]**
- `location_settings`: JSONB field for location settings (includes location_up, services_up, availability_up, rate)

**Relations:**
- `profile`: Many-to-one with Profile
- `members`: One-to-many with LocationMembers
- `availability`: One-to-many with LocationAvailability
- `appointments`: One-to-many with Appointments
- `services`: One-to-many with LocationService (artist-location-services)

**Note:** `services_up` and `availability_up` exist both as direct columns and within the `location_settings` JSONB field.

### 9. LocationMember (`location_members`)
Manages membership relationships between users and locations.

**Fields:**
- `id`: UUID (primary key)
- `role`: Enum - 'member', 'manager', 'super-admin'
- `location_member_settings`: JSONB field for member settings
- `accepted_at`: Timestamp when invitation was accepted (nullable)
- `declined_at`: Timestamp when invitation was declined (nullable)
- `invitation_token`: Token for invitation process (nullable)
- `token_expiration_date`: Token expiration timestamp (nullable)
- `is_active`: Active status (default true)

**Relations:**
- `organization`: Many-to-one with Profile (parent organization)
- `location`: Many-to-one with Location (work location, nullable)
- `artist`: Many-to-one with Profile (artist profile, nullable)
- `member`: Many-to-one with User (the member user)

### 10. Times (`times`)
Time slots for appointments and availability.

**Fields:**
- `id`: Integer (primary key)
- `time`: Time of day (TIME type)

**Relations:**
- `locations_start_time`: One-to-many with LocationAvailability (as start time)
- `locations_end_time`: One-to-many with LocationAvailability (as end time)
- `appointments_start_time`: One-to-many with Appointments (as start time)
- `appointments_end_time`: One-to-many with Appointments (as end time)

### 11. AvailabilityTemplate (`availability_templates`)
Predefined availability patterns.

**Fields:**
- `id`: UUID (primary key)
- `name`: Unique template name
- `description`: Template description (nullable)

**Relations:**
- `items`: One-to-many with LocationAvailability

### 12. LocationAvailability (`artist_location_availability`)
Location availability schedules by day of week.

**Fields:**
- `id`: UUID (primary key)
- `weekday`: Day of week (0-6)
- `location_id`: UUID of location (nullable)
- `template_id`: UUID of availability template (nullable)
- `start_time_id`: Integer referencing Time
- `end_time_id`: Integer referencing Time

**Relations:**
- `start_time`: Many-to-one with Time
- `end_time`: Many-to-one with Time
- `location`: Many-to-one with Location
- `template`: Many-to-one with AvailabilityTemplate

## Appointment Entities

### 13. Appointments (`appointments`)
Scheduled appointments between clients and profiles.

**Fields:**
- `id`: UUID (primary key)
- `date`: Appointment date (DATE type)
- `duration`: Total duration in minutes (float)
- `price`: Total price (integer)
- `rate`: Client rating (nullable, float)
- `comment`: Client comment (nullable)

**Relations:**
- `client`: Many-to-one with User
- `profile`: Many-to-one with Profile
- `location`: Many-to-one with Location
- `state`: Many-to-one with AppointmentState
- `start_time`: Many-to-one with Time
- `end_time`: Many-to-one with Time
- `services`: One-to-many with AppointmentServices

### 14. AppointmentState (`appointment_state`)
Possible states for appointments.

**Fields:**
- `id`: Integer (primary key)
- `name`: State name

**Relations:**
- `appointments`: One-to-many with Appointments

### 15. AppointmentService (`appointment_services`)
Services included in an appointment (junction table).

**Fields:**
- `appointment_id`: UUID (composite primary key)
- `service_id`: UUID (composite primary key)
- `duration`: Service duration for this appointment (integer)
- `price`: Service price for this appointment (float)

**Relations:**
- `appointment`: Many-to-one with Appointment
- `service`: Many-to-one with ArtistService

## Content & Media Entities

### 16. ProfileMedia (`profile_media`)
Media files associated with profiles and posts.

**Fields:**
- `id`: UUID (primary key)
- `mime_type`: MIME type of the media
- `media_url`: URL to the media file

**Relations:**
- `profile`: Many-to-one with Profile
- `post`: Many-to-one with ProfilePost (nullable)

### 17. ProfilePost (`profile_posts`)
Social media style posts by profiles.

**Fields:**
- `id`: UUID (primary key)
- `description`: Post description (nullable)

**Relations:**
- `profile`: Many-to-one with Profile
- `media`: One-to-many with ProfileMedia
- `categories`: Many-to-many with Categories

## Interaction Entities

### 18. UserProfileInteraction (`user_profile_interactions`)
Tracks user interactions with profiles.

**Fields:**
- `user_id`: UUID (composite primary key)
- `profile_id`: UUID (composite primary key)
- `appointments_count`: Number of appointments (default 0)
- `is_favorite`: Favorite status
- `is_liked`: Like status
- `is_spam`: Spam flag

**Relations:**
- `user`: Many-to-one with User
- `profile`: Many-to-one with Profile

## Entity Relationship Overview

### Core Relationships:
1. **Users ↔ Profiles**: One user can own multiple profiles
2. **Profiles ↔ Locations**: One profile can have multiple locations
3. **Locations ↔ LocationServices**: Each location offers multiple services
4. **Users ↔ Appointments ↔ Profiles**: Users book appointments with profiles
5. **Categories ↔ ServicesTemplates**: Service template hierarchy
6. **LocationMembers**: Manages user-location-organization relationships
7. **Times**: Central time management for availability and appointments

### Key Junction Tables:
- `AppointmentServices`: Links appointments with multiple artist services
- `UserProfileInteractions`: Tracks user-profile relationship metrics
- `LocationMembers`: Organization membership and location assignments

### Service Architecture:
- **ServicesTemplate & ServicesTemplateItem**: Template-based service definitions for categories
- **LocationService** (unified table): Location-specific service offerings accessed by two contexts:
  - Services context: Manages general location services with descriptions
  - Artist-location-services context: Manages artist-specific services with active status
- **ArtistService**: Artist-specific customizations and pricing of location services
- **AppointmentService**: Actual services booked in appointments with appointment-specific pricing and duration

### Geographic Features:
- User and Location entities include PostGIS Point geometry for location-based queries
- Address fields support international locations with defaults for Colombia

### Membership System:
- **LocationMembers** handles complex organization structures
- Supports roles: member, manager, super-admin
- Supports both user and artist profile associations
- Invitation system with tokens and expiration dates

### Soft Deletion:
- Most entities inherit soft deletion capability through BaseEntity
- Enables data recovery and audit trails

## Updated Structure Summary:

This structure supports a comprehensive beauty and wellness appointment booking platform with:
- Multi-location organizations
- Flexible service template system
- Complex membership hierarchies
- Rich user interaction tracking
- Geographic location services
- Location-based service offerings architecture
- Enhanced service management with multiple service entity types
- JSONB-based settings for flexible configuration (user_settings, profile_settings, location_settings, location_member_settings)
- Soft deletion support through BaseEntity

## Important Notes:

### Settings Structures (JSONB Fields):

#### 1. User Settings (`user_settings`)
**Type:** `Usersettings`

**Fields:**
- `is_organization_member`: boolean - Indicates if the user is a member of any organization
- `is_first_login`: boolean - Flag for first-time login tracking

**Default Values:**
```json
{
  "is_organization_member": false,
  "is_first_login": true
}
```

#### 2. Profile Settings (`profile_settings`)
**Type:** `ProfileSettings` (union of `ArtistProfilesettings` | `OrganizationProfilesettings`)

**Common Fields (for all profile types):**
- `rate`: number - Profile rating (default: 5)

**Artist Profile Additional Fields:**
- `independent_state_up`: boolean - Independent artist setup completion status
- `independent_artist`: boolean - Whether the artist operates independently

**Default Values for Artist:**
```json
{
  "independent_state_up": false,
  "independent_artist": true,
  "rate": 5
}
```

**Default Values for Organization:**
```json
{
  "rate": 5
}
```

#### 3. Location Settings (`location_settings`)
**Type:** `Locationsettings`

**Fields:**
- `location_up`: boolean - Location setup completion status
- `services_up`: boolean - Services configuration status
- `availability_up`: boolean - Availability configuration status
- `rate`: number - Location rating (inherited from CommonProfileSettings)

**Default Values:**
```json
{
  "location_up": false,
  "services_up": false,
  "availability_up": false,
  "rate": 5
}
```

#### 4. Location Member Settings (`location_member_settings`)
**Type:** `LocationMembersettings`

**Fields:**
- `services_up`: boolean - Member services configuration status
- `availability_up`: boolean - Member availability configuration status

**Default Values:**
```json
{
  "services_up": false,
  "availability_up": false
}
```

### Table Name Conflicts:
- **RESOLVED:** The table name conflict for `location_services` has been resolved by merging the two entity definitions into one unified table
- The unified `location_services` table now contains fields from both contexts:
  - `description` (text) - for general location services
  - `is_active` (boolean) - for artist location service management
  - Both unique constraints are maintained:
    - `(name, location_id)` - ensures unique service names per location
    - `(name, subcategory_id)` - ensures unique service names per subcategory
- Two different `LocationServiceEntity` classes (from different contexts) access this same table, each using the fields relevant to their use case

### Settings Architecture:
All major entities now use JSONB fields for flexible configuration:
- Users: `user_settings`
- Profiles: `profile_settings`
- Locations: `location_settings`
- LocationMembers: `location_member_settings`

This allows for dynamic configuration without schema changes.

**Important:** The `locations` table has `services_up` and `availability_up` as both direct columns AND within the `location_settings` JSONB field. This may be for backward compatibility or query performance optimization.
