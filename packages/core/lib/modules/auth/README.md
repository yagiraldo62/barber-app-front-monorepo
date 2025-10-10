# Extensible Auth Module

This auth module is designed to be extensible, allowing each app in the monorepo to implement its own authentication logic while sharing common functionality.

## Architecture

The auth module follows a callback-based architecture that allows each app to customize authentication behavior:

### Core Components

1. **AuthCallbacks Interface** (`interfaces/auth_callbacks.dart`)
   - Defines the contract that each app must implement
   - Contains callback methods for login, logout, redirection, and validation

2. **BaseAuthActionsController** (`controllers/base_auth_actions_controller.dart`)
   - Abstract base class for auth actions
   - Apps extend this and provide their own callbacks

3. **BaseGuardController** (`controllers/base_guard_controller.dart`)
   - Abstract base class for auth guards
   - Apps extend this for their own guard logic

### Auth State Management

The `AuthState` class contains:
- `token`: Authentication token
- `user`: Current user model
- `selectedScope`: Currently selected artist (for business apps)

## Implementation Guide

### Step 1: Create Auth Callbacks

Each app must implement the `AuthCallbacks` interface:

```dart
class MyAppAuthCallbacks implements AuthCallbacks {
  @override
  Future<void> onLogin(UserModel user) async {
    // App-specific login logic
  }

  @override
  void onLoginRedirection(UserModel? user) {
    // App-specific redirection logic
  }

  @override
  Future<void> onLogout() async {
    // App-specific logout cleanup
  }

  @override
  Future<UserModel> onSetUserLocation(UserModel user) async {
    // App-specific location setting
    return user;
  }

  @override
  Future<void> onFirstLoginCompleted(UserModel user) async {
    // App-specific first login completion
  }

  @override
  Future<void> onAuthValidation(UserModel? user, ArtistModel? selectedScope) async {
    // App-specific auth validation
  }
}
```

### Step 2: Create Controllers

Extend the base controllers:

```dart
class MyAppAuthActionsController extends BaseAuthActionsController {
  late final AuthCallbacks _authCallbacks;

  MyAppAuthActionsController() {
    _authCallbacks = MyAppAuthCallbacks();
  }

  @override
  AuthCallbacks get authCallbacks => _authCallbacks;
}

class MyAppAuthGuardController extends BaseGuardController {
  late final AuthCallbacks _authCallbacks;

  MyAppAuthGuardController() {
    _authCallbacks = MyAppAuthCallbacks();
  }

  @override
  AuthCallbacks get authCallbacks => _authCallbacks;
}
```

### Step 3: Create Binding

Create an app-specific binding:

```dart
class MyAppAuthBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies
    Get.put<AuthProvider>(AuthProvider());
    Get.put<UserRepository>(UserRepository());
    Get.put<AuthRepository>(AuthRepository());
    Get.put<AuthController>(AuthController());

    // App-specific controllers
    Get.put<MyAppAuthActionsController>(MyAppAuthActionsController());
    Get.put<MyAppAuthGuardController>(MyAppAuthGuardController());
  }
}
```

### Step 4: Use in Views

Use the app-specific controllers in your views:

```dart
class MyAuthView extends GetView {
  @override
  Widget build(BuildContext context) {
    Get.find<MyAppAuthGuardController>();
    var authController = Get.find<MyAppAuthActionsController>();
    
    return Scaffold(
      body: ElevatedButton(
        onPressed: () => authController.signInWithFacebook(),
        child: Text('Login'),
      ),
    );
  }
}
```

## Example Implementations

### Business App (Provider/Artist focused)
- Handles artist selection and management
- Redirects to artist-specific screens
- Manages artist locations and services

### Client App (Customer focused)
- No artist functionality
- Client-specific onboarding flow
- Customer-focused navigation

## Callback Methods Explained

### `onLogin(UserModel user)`
Called when a user successfully logs in. Handle:
- User location setting
- Initial data loading
- Setting selected artist (for business apps)
- Saving auth state

### `onLoginRedirection(UserModel? user)`
Called to redirect user after login. Handle:
- First-time user flow
- Different user types (artist vs client)
- Route navigation

### `onLogout()`
Called when user logs out. Handle:
- Clearing cached data
- Resetting app state
- Cleanup operations

### `onSetUserLocation(UserModel user)`
Called to set user's current location. Handle:
- Geolocation permissions
- Location accuracy
- Privacy settings

### `onFirstLoginCompleted(UserModel user)`
Called when first-time user completes onboarding. Handle:
- Updating user preferences
- Setting up initial data
- Completing registration

### `onAuthValidation(UserModel? user, ArtistModel? selectedScope)`
Called by guards to validate auth state. Handle:
- Permission checks
- User status validation
- Conditional redirections

## Benefits

1. **Separation of Concerns**: Each app handles its own auth logic
2. **Code Reuse**: Common functionality is shared via base classes
3. **Flexibility**: Apps can customize any part of the auth flow
4. **Maintainability**: Changes to one app don't affect others
5. **Testability**: Each app's auth logic can be tested independently
