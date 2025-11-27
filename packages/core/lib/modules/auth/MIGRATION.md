# Migration Guide: From Legacy Auth to Extensible Auth

This guide helps you migrate from the legacy auth controllers to the new extensible auth system.

## Overview

The auth module has been refactored to support multiple app types with different authentication behaviors. The new system uses a callback-based architecture that allows each app to implement its own business logic.

## What Changed

### Before (Legacy)
```dart
// Old way - hardcoded business logic in core
class AuthActionsController extends GetxController {
  void onLogin(UserModel user) {
    // Hardcoded artist-specific logic
    if (user.artists?.isNotEmpty == true) {
      // Set selected artist
    }
    // Hardcoded redirection logic
  }
}
```

### After (Extensible)
```dart
// New way - callbacks for customization
class BusinessAuthCallbacks implements AuthCallbacks {
  @override
  Future<void> onLogin(UserModel user) async {
    // Business-specific login logic
  }
  
  @override
  void onLoginRedirection(UserModel? user) {
    // Business-specific redirection logic
  }
}

class BusinessAuthActionsController extends BaseAuthActionsController {
  @override
  AuthCallbacks get authCallbacks => BusinessAuthCallbacks();
}
```

## Step-by-Step Migration

### 1. Update Imports

**Before:**
```dart
import 'package:core/modules/auth/controllers/auth_actions_controller.dart';
import 'package:core/modules/auth/controllers/guards/auth_guard_controller.dart';
import 'package:core/modules/auth/controllers/guards/guest_guard_controller.dart';
```

**After:**
```dart
import 'package:your_app/modules/auth/controllers/your_app_auth_actions_controller.dart';
import 'package:your_app/modules/auth/controllers/your_app_auth_guard_controller.dart';
import 'package:your_app/modules/auth/controllers/your_app_guest_guard_controller.dart';
```

### 2. Update Controller Usage

**Before:**
```dart
class AuthView extends GetView {
  @override
  Widget build(BuildContext context) {
    Get.find<GuestGuardController>();
    var authController = Get.find<AuthActionsController>();
    
    return ElevatedButton(
      onPressed: () => authController.signInWithFacebook(),
      child: Text('Login'),
    );
  }
}
```

**After:**
```dart
class AuthView extends GetView {
  @override
  Widget build(BuildContext context) {
    Get.find<YourAppGuestGuardController>();
    var authController = Get.find<YourAppAuthActionsController>();
    
    return ElevatedButton(
      onPressed: () => authController.signInWithFacebook(),
      child: Text('Login'),
    );
  }
}
```

### 3. Update Bindings

**Before:**
```dart
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthActionsController>(AuthActionsController());
    Get.put<AuthGuardController>(AuthGuardController());
    Get.put<GuestGuardController>(GuestGuardController());
  }
}
```

**After:**
```dart
class YourAppAuthBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies (still needed)
    Get.put<AuthProvider>(AuthProvider());
    Get.put<UserRepository>(UserRepository());
    Get.put<AuthRepository>(AuthRepository());
    Get.put<AuthController>(AuthController());
    
    // Your app-specific controllers
    Get.put<YourAppAuthActionsController>(YourAppAuthActionsController());
    Get.put<YourAppAuthGuardController>(YourAppAuthGuardController());
    Get.put<YourAppGuestGuardController>(YourAppGuestGuardController());
  }
}
```

## Creating Your App's Implementation

### 1. Create Auth Callbacks

Create `lib/app/auth/controllers/your_app_auth_callbacks.dart`:

```dart
import 'package:core/modules/auth/interfaces/auth_callbacks.dart';
import 'package:core/data/models/user_model.dart';
import 'package:core/data/models/artist_model.dart';

class YourAppAuthCallbacks implements AuthCallbacks {
  @override
  Future<void> onLogin(UserModel user) async {
    // Your app's login logic
  }

  @override
  void onLoginRedirection(UserModel? user) {
    // Your app's redirection logic
  }

  @override
  Future<void> onLogout() async {
    // Your app's logout cleanup
  }

  @override
  Future<UserModel> onSetUserLocation(UserModel user) async {
    // Your app's location setting logic
    return user;
  }

  @override
  Future<void> onFirstLoginCompleted(UserModel user) async {
    // Your app's first login completion logic
  }

  @override
  Future<void> onAuthValidation(UserModel? user, ArtistModel? selectedScope) async {
    // Your app's auth validation logic
  }
}
```

### 2. Create Controllers

Create your app-specific controllers that extend the base controllers and use your callbacks.

### 3. Update Routes and Bindings

Update your route bindings to use the new controllers.

## Business App Example

The business app implementation serves as a complete example of the new pattern. See:

- `apps/bartoo-business/lib/app/auth/controllers/business_auth_callbacks.dart`
- `apps/bartoo-business/lib/app/auth/controllers/business_auth_actions_controller.dart`
- `apps/bartoo-business/lib/app/auth/controllers/business_auth_guard_controller.dart`
- `apps/bartoo-business/lib/app/auth/bindings/business_auth_binding.dart`

## Benefits of Migration

1. **Flexibility**: Each app can implement its own auth logic
2. **Separation**: Business logic is separated from core functionality
3. **Reusability**: Common auth functionality is still shared
4. **Maintainability**: Changes to one app don't affect others
5. **Testability**: Each app's auth logic can be tested independently

## Legacy Support

The old controllers are still available but marked as deprecated. They will continue to work but it's recommended to migrate to the new system for better maintainability.

## Need Help?

Check the README.md in the auth module for detailed implementation examples, or refer to the business app implementation as a complete working example.
