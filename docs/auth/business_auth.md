# Authentication in the Business App

This document describes the implementation of authentication in the Business app, based on the core authentication module.

## Overview

The Business app extends the core authentication module to include artist-specific functionality. It uses custom callbacks and controllers to handle business-specific authentication logic.

## Implementation

### Auth Callbacks

**File:** `apps/bartoo-business/lib/app/modules/auth/controllers/business_auth_callbacks.dart`

The `BusinessAuthCallbacks` class implements the `AuthCallbacks` interface and provides the following methods:

- `onLogin(UserModel user)`: Sets the selected artist and handles artist-specific login logic.
- `onLoginRedirection(UserModel? user)`: Redirects the user to the artist home screen or intro screen.
- `onLogout()`: Clears artist-specific data and handles logout cleanup.
- `onSetUserLocation(UserModel user)`: Sets the artist's location.
- `onFirstLoginCompleted(UserModel user)`: Handles first-time login completion for artists.
- `onAuthValidation(UserModel? user, ArtistModel? selectedArtist)`: Validates the authentication state for artists.

### Auth Controllers

**Files:**
- `BusinessAuthActionsController`: Extends `BaseAuthActionsController` and uses `BusinessAuthCallbacks`.
- `BusinessAuthGuardController`: Extends `BaseGuardController` to validate authentication state.
- `BusinessGuestGuardController`: Extends `BaseGuardController` to validate guest state.

### Auth Binding

**File:** `apps/bartoo-business/lib/app/modules/auth/bindings/business_auth_binding.dart`

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

### Validation
1. Guards validate the authentication state on app start or route changes.
2. The `onAuthValidation` callback validates the authentication state for artists.

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