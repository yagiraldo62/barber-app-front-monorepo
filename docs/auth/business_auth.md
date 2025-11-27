# Authentication in the Business App

This document describes the implementation of authentication in the Business app, based on the core authentication module.

## Overview

The Business app extends the core authentication module to include artist-specific functionality. It uses custom callbacks and controllers to handle business-specific authentication logic.

## Implementation

### Auth Callbacks

**File:** `apps/bartoo-business/lib/app/auth/controllers/business_auth_callbacks.dart`

The `BusinessAuthCallbacks` class implements the `AuthCallbacks` interface and provides the following methods:

- `onLogin(UserModel user)`: Sets the selected artist and handles artist-specific login logic.
- `onLoginRedirection(UserModel? user)`: Redirects the user to the artist home screen or intro screen.
- `onLogout()`: Clears artist-specific data and handles logout cleanup.
- `onSetUserLocation(UserModel user)`: Sets the artist's location.
- `onFirstLoginCompleted(UserModel user)`: Handles first-time login completion for artists.
- `onAuthValidation(UserModel? user, ArtistModel? selectedScope)`: Validates the authentication state for artists.

### Auth Controllers

**Files:**
- `BusinessAuthActionsController`: Extends `BaseAuthActionsController` and uses `BusinessAuthCallbacks`.
- `BusinessAuthGuardController`: Extends `BaseGuardController` to validate authentication state.
- `BusinessGuestGuardController`: Extends `BaseGuardController` to validate guest state.

### Auth Binding

**File:** `apps/bartoo-business/lib/app/auth/bindings/business_auth_binding.dart`

The `BusinessAuthBinding` class registers all dependencies, including:
- Core dependencies (e.g., `AuthProvider`, `UserRepository`, `AuthRepository`)
- Business-specific controllers (e.g., `BusinessAuthActionsController`, `BusinessAuthGuardController`)

## Authentication Flow

### Login
1. The user initiates login (e.g., via Facebook).
2. The `signInWithFacebook` method in `BusinessAuthActionsController` is called.
3. On successful login, the `onLogin` callback sets the selected artist.
4. The `onLoginRedirection` callback redirects the user to the artist home screen or intro screen.

### Logout
1. The user initiates logout.
2. The `onLogout` callback clears artist-specific data and handles cleanup.

### Auth Validation & Redirections

The authentication validation system ensures users are properly authenticated and verified before accessing protected routes. The redirection flow follows this priority order:

#### 1. Guest Route Validation (`guestRouteValidation`)
- If user is null and not on home route → redirect to home (`/`)
- This ensures unauthenticated users are sent to the home page

#### 2. Auth Routes Validation (`authRoutesValidation`)
The validation runs on protected routes and follows this order:

**Step 1: Null User Check**
- If user is null and not on home route → redirect to home (`/`)

**Step 2: Phone Verification (Prerequisite)**
- Early exit if already on `/verify-phone` route (prevents infinite loops)
- If user is not phone verified AND not on verify-phone route → redirect to `/verify-phone`
- If user IS phone verified AND on verify-phone route → redirect to `/` (home)
- Phone verification is a prerequisite before any other setup

**Step 3: Setup Route Check**
- If already on a setup route (intro, profile setup, location setup, etc.) → skip further validation
- Setup routes are excluded from mandatory flow redirection

**Step 4: User State Validation** (only if NOT in setup route)
- **First Login**: If `user.isFirstLogin == true` → redirect to intro (`/intro`)
- **Pending Invitation**: If user has a pending invitation → redirect to invitation view
- **No Selected Scope**: If no selected scope exists → redirect to profile creation

**Step 5: Scope-Based Redirection**
- **ProfileScope** (owns profile):
  - If organization with no locations → redirect to location setup
  - If organization with incomplete services/availability → redirect to location setup
  - If independent artist with incomplete setup → redirect to profile setup
- **LocationMemberScope** (employee/member):
  - If organization not set → redirect to organization setup
  - If location with incomplete setup → redirect to location setup

### Setup Routes (Skip Redirection Logic)
The following routes skip the mandatory flow redirection:
- `/intro` - First login introduction
- `/profiles/:profile_id/setup` - Profile setup
- `/profiles/:profile_id/:location_id/setup` - Location setup
- `/profiles/:profile_id/locations/new` - Create location
- `/members` - Manage members/invitations

### Middleware Integration
Routes with `AuthGuardMiddleware` automatically run auth validation on entry:
- Home (`/`)
- Profile (`/profile`)
- Artist Home (`/artist-home`)
- Setup routes
- Services update
- And other protected routes

This ensures authentication state is validated every time these protected routes are accessed.

## Validation

## Example

### Login Button

```dart
ElevatedButton(
  onPressed: () => Get.find<BusinessAuthActionsController>().signInWithFacebook(),
  child: Text('Login'),
);
```

### Guard Example

```dart
Get.find<BusinessAuthGuardController>().validateAuthState();
```

## Benefits

1. **Custom Logic**: Handles artist-specific authentication logic.
2. **Extensibility**: Easily extendable for future business requirements.
3. **Separation of Concerns**: Business logic is separated from core functionality.