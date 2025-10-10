# Core Authentication Module

This document provides an overview of the core authentication module, its architecture, and its extensibility for multiple apps in the monorepo.

## Overview

The authentication module is designed to be extensible, allowing each app to implement its own authentication logic while sharing common functionality. It uses a callback-based architecture to separate app-specific logic from shared core functionality.

## Core Components

### 1. AuthCallbacks Interface

**File:** `packages/core/lib/modules/auth/interfaces/auth_callbacks.dart`

The `AuthCallbacks` interface defines the contract that each app must implement. It contains the following methods:

- `onLogin(UserModel user)`: Handles app-specific login logic.
- `onLoginRedirection(UserModel? user)`: Redirects users after login.
- `onLogout()`: Handles app-specific logout cleanup.
- `onSetUserLocation(UserModel user)`: Sets the user's location.
- `onFirstLoginCompleted(UserModel user)`: Handles first-time login completion.
- `onAuthValidation(UserModel? user, ArtistModel? selectedScope)`: Validates the authentication state.

### 2. BaseAuthActionsController

**File:** `packages/core/lib/modules/auth/controllers/base_auth_actions_controller.dart`

This abstract class provides shared functionality for authentication actions. Apps extend this class and provide their own `AuthCallbacks` implementation.

### 3. BaseGuardController

**File:** `packages/core/lib/modules/auth/controllers/base_guard_controller.dart`

This abstract class provides shared functionality for authentication guards. Apps extend this class to implement their own guard logic.

### 4. AuthState

**File:** `packages/core/lib/modules/auth/state/auth_state.dart`

The `AuthState` class manages the authentication state, including:
- `token`: The authentication token.
- `user`: The current user model.
- `selectedScope`: The currently selected artist (for business apps).

## Authentication Flow

### Login
1. The user initiates login (e.g., via Facebook).
2. The `signInWithFacebook` method in the app-specific `AuthActionsController` is called.
3. On successful login, the `onLogin` callback is triggered to handle app-specific logic.
4. The `onLoginRedirection` callback redirects the user to the appropriate screen.

### Logout
1. The user initiates logout.
2. The `onLogout` callback is triggered to handle app-specific cleanup.
3. The authentication state is cleared.

### Validation
1. Guards validate the authentication state on app start or route changes.
2. The `onAuthValidation` callback is triggered to handle app-specific validation logic.

## Benefits

1. **Separation of Concerns**: Each app handles its own authentication logic.
2. **Code Reuse**: Common functionality is shared via base classes.
3. **Flexibility**: Apps can customize any part of the authentication flow.
4. **Maintainability**: Changes to one app don't affect others.
5. **Testability**: Each app's authentication logic can be tested independently.