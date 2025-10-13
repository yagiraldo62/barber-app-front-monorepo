# Auth Module - User Type Views

This document describes the new views created for handling different user types who might access the business app incorrectly.

## Overview

Three new components have been created to handle edge cases where users access the wrong application or don't have proper permissions:

1. **ClientAppLink Widget** - Reusable widget that shows a link to the client app
2. **NoOrganizationView** - For collaborators without an assigned organization
3. **WrongAppView** - For regular clients who opened the business app by mistake

## Files Created

### 1. ClientAppLink Widget
**Path:** `apps/bartoo-business/lib/app/modules/auth/views/widgets/client_app_link.dart`

**Purpose:** Reusable widget that displays information about the client app with a link to download/access it.

**Features:**
- Informative card design
- Link to client app (configurable via `clientAppUrl` constant)
- Opens link in external browser
- Theme-aware styling

**Usage:**
```dart
import 'package:bartoo/app/modules/auth/views/widgets/client_app_link.dart';

// In your widget tree
const ClientAppLink()
```

**Configuration:**
Update the `clientAppUrl` constant in the widget to point to your actual client app:
```dart
static const String clientAppUrl = 'https://bartoo.app/client';
```

You can also configure this via environment variables by modifying the widget.

---

### 2. NoOrganizationView
**Path:** `apps/bartoo-business/lib/app/modules/auth/views/no_organization_view.dart`

**Purpose:** Displayed to collaborator/location member users who have successfully authenticated but don't have an organization assigned yet.

**When to Show:**
- User has `LocationMemberScope` type
- User's `locationMember.organization` is `null`
- User is not a profile owner

**Features:**
- Welcoming personalized message
- Clear explanation of the situation
- Instructions to contact organization admin
- Link to client app (via ClientAppLink widget)
- Logout option
- Theme toggle button

**Example Usage in Guard Controller:**
```dart
// In your auth guard/guard controller
if (scope is LocationMemberScope) {
  if (scope.locationMember.organization == null) {
    // User is a collaborator but no organization assigned
    Get.offAllNamed(Routes.NO_ORGANIZATION);
    return;
  }
}
```

**UI Elements:**
- Business icon in a circular container
- Personalized greeting with user's name
- Informative message box
- Client app link widget
- Logout button at the bottom

---

### 3. WrongAppView
**Path:** `apps/bartoo-business/lib/app/modules/auth/views/wrong_app_view.dart`

**Purpose:** Displayed to regular client users who accidentally opened the business app instead of the client app.

**When to Show:**
- User is authenticated
- User has no profiles (not a professional)
- User has no location memberships (not a collaborator)
- User is essentially a regular client

**Features:**
- Friendly explanation they're in the wrong app
- Link to the correct client app
- Option to select account type (if they are actually a professional)
- Logout option
- Theme toggle button

**Example Usage in Guard Controller:**
```dart
// In your auth guard/guard controller
if (user.profiles.isEmpty && user.locationMemberships.isEmpty) {
  // User is a regular client in the wrong app
  Get.offAllNamed(Routes.WRONG_APP);
  return;
}
```

**UI Elements:**
- Swap icon in a circular container (error color theme)
- Personalized greeting
- Clear message explaining they're in the business app
- Client app link widget
- Divider with "or" text
- Professional account option (links to intro view)
- Logout button at the bottom

---

## Routes Setup

Add these routes to your `app_routes.dart`:

```dart
abstract class Routes {
  // ... existing routes
  static const NO_ORGANIZATION = _Paths.NO_ORGANIZATION;
  static const WRONG_APP = _Paths.WRONG_APP;
}

abstract class _Paths {
  // ... existing paths
  static const NO_ORGANIZATION = '/no-organization';
  static const WRONG_APP = '/wrong-app';
}
```

Add to `app_pages.dart`:

```dart
static final routes = [
  // ... existing routes
  GetPage(
    name: _Paths.NO_ORGANIZATION,
    page: () => const NoOrganizationView(),
  ),
  GetPage(
    name: _Paths.WRONG_APP,
    page: () => const WrongAppView(),
  ),
];
```

---

## Integration with Guard Controller

Here's how to integrate these views into your `BusinessAuthGuardController` or similar:

```dart
Future<void> validateUserAccess(UserModel user) async {
  // Set default scope
  final scope = await authController.setAuthDefaultScope(user: user);

  if (scope == null) {
    // No valid scope found - user might be a regular client
    if (user.profiles.isEmpty && user.locationMemberships.isEmpty) {
      // Regular client in wrong app
      Get.offAllNamed(Routes.WRONG_APP);
      return;
    }
    // Other cases where scope is null
    Get.offAllNamed(Routes.AUTH);
    return;
  }

  // Check for collaborator without organization
  if (scope is LocationMemberScope) {
    if (scope.locationMember.organization == null) {
      Get.offAllNamed(Routes.NO_ORGANIZATION);
      return;
    }
  }

  // User has valid scope, proceed to main app
  Get.offAllNamed(Routes.HOME);
}
```

---

## User Flows

### Flow 1: Collaborator Without Organization

```
User logs in
    ↓
Guard checks user type
    ↓
User has locationMemberships but organization is null
    ↓
Redirect to NoOrganizationView
    ↓
User sees:
- Message explaining they need organization assignment
- Instructions to contact admin
- Link to client app
- Logout option
```

### Flow 2: Regular Client in Business App

```
User logs in
    ↓
Guard checks user type
    ↓
User has no profiles and no locationMemberships
    ↓
Redirect to WrongAppView
    ↓
User sees:
- Message explaining they're in the business app
- Link to client app (primary action)
- Option to select professional account type
- Logout option
```

---

## Customization

### Client App URL

To configure the client app URL, you have several options:

**Option 1: Direct modification**
Edit `client_app_link.dart`:
```dart
static const String clientAppUrl = 'https://your-client-app.com';
```

**Option 2: Environment variable**
1. Add to `.env`:
```
CLIENT_APP_URL=https://your-client-app.com
```

2. Modify `client_app_link.dart`:
```dart
static final String clientAppUrl = 
    dotenv.env['CLIENT_APP_URL'] ?? 'https://bartoo.app/client';
```

### Styling

All views use theme-aware widgets, so they automatically adapt to:
- Light/dark mode
- Custom color schemes
- Typography variations

To customize specific elements, modify the respective view files.

### Text Content

All text strings are currently hardcoded in Spanish. To support internationalization:

1. Extract strings to locale files
2. Use GetX translations or similar i18n package
3. Replace hardcoded strings with translation keys

---

## Testing

### Manual Testing

**Test NoOrganizationView:**
1. Create a user with locationMemberships
2. Set organization to null for that membership
3. Log in with that user
4. Verify the view appears with correct message
5. Test logout button
6. Test client app link

**Test WrongAppView:**
1. Create a user with no profiles and no locationMemberships
2. Log in with that user
3. Verify the view appears
4. Test client app link
5. Test "Select account type" button (should go to intro)
6. Test logout button

### Automated Testing

Create widget tests:

```dart
testWidgets('NoOrganizationView displays correctly', (tester) async {
  // Setup mock controller
  final mockController = MockBaseAuthController();
  when(mockController.user).thenReturn(Rx(mockUser));
  
  await tester.pumpWidget(
    GetMaterialApp(
      home: NoOrganizationView(),
    ),
  );
  
  expect(find.text('Aún no tienes una organización asignada'), findsOneWidget);
  expect(find.byType(ClientAppLink), findsOneWidget);
  expect(find.text('Cerrar sesión'), findsOneWidget);
});
```

---

## Dependencies

These views use the following packages:
- `get` - For navigation and state management
- `url_launcher` - For opening external links (client app)
- `ui` package - For reusable UI components
- `core` package - For auth controllers and models

---

## Future Enhancements

Potential improvements:
1. Add QR code to download client app
2. Support deep linking to specific sections of client app
3. Add analytics tracking for users who land on these views
4. Email notification to admin when collaborator needs organization assignment
5. In-app chat support widget
6. Localization/internationalization support
7. Animated transitions between states
8. App store badges for iOS and Android client apps

---

## Troubleshooting

**Issue: Client app link doesn't open**
- Check `url_launcher` permissions in AndroidManifest.xml and Info.plist
- Verify the URL is valid and accessible
- Check device logs for URL launch errors

**Issue: Views not showing**
- Verify routes are properly configured in `app_pages.dart`
- Check guard controller logic for correct conditions
- Ensure GetX controllers are properly initialized

**Issue: User name not displaying**
- Verify `BaseAuthController.user.value` is properly populated
- Check that user model has `name` field
- Add null safety checks

---

## Related Files

- `apps/bartoo-business/lib/app/modules/auth/controllers/business_auth_guard_controller.dart`
- `apps/bartoo-business/lib/app/modules/auth/views/first_login_intro/first_login_intro_view.dart`
- `apps/bartoo-business/lib/app/routes/app_pages.dart`
- `apps/bartoo-business/lib/app/routes/app_routes.dart`
