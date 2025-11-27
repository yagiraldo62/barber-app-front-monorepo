# Implementation Plan: Separate Update Views for Profiles and Locations

## Overview
Create dedicated views for updating profiles and locations independently, without going through the full setup flow. The setup flow remains unchanged for initial configuration.

---

## 1. Update Profile Feature

### 1.1 Controller: `UpdateProfileController`
**Path:** `app/profiles/controllers/update_profile_controller.dart`

**Responsibilities:**
- Get `profile_id` from route parameter `:profile_id`
- Initialize `currentProfile` by searching:
  1. `user.profiles` (owned profiles)
  2. `user.locationsWorked[].organization` (profiles where user is a member)
- Handle profile save callback
- Refresh user data after update
- Navigate back after successful save

**Key Methods:**
- `_loadProfileFromRoute()` - Loads profile from route param
- `onProfileSaved(ProfileModel)` - Handles save callback

### 1.2 View: `UpdateProfileView`
**Path:** `app/profiles/views/update_profile_view.dart`

**Structure:**
```dart
Scaffold(
  appBar: AppBar with back button and title,
  body: Obx(() {
    if (!controller.isInitialized) return CircularProgressIndicator;
    if (controller.currentProfile == null) return Error message;
    
    return ProfileForm(
      currentProfile: controller.currentProfile.value,
      isCreation: false,
      onSaved: controller.onProfileSaved,
    );
  }),
)
```

### 1.3 Binding: `UpdateProfileBinding`
**Path:** `app/profiles/bindings/update_profile_binding.dart`

**Injects:**
- `UpdateProfileController`

### 1.4 Route
**Pattern:** `/profiles/:profile_id/edit`
**Constant:** `Routes.updateProfile`

---

## 2. Update Location Feature

### 2.1 Controller: `UpdateLocationController`
**Path:** `app/locations/controllers/update_location_controller.dart`

**Responsibilities:**
- Get `profile_id` and `location_id` from route parameters
- Initialize `currentProfile` and `currentLocation` by searching:
  - `user.locationsWorked[]` - Find matching organization and location
  - Fallback to `user.profiles[]` if profile is owned
- Handle location save callback
- Refresh user data after update
- Navigate back after successful save

**Key Methods:**
- `_loadFromRoute()` - Loads profile and location from route params
- `onLocationSaved(LocationModel)` - Handles save callback

### 2.2 View: `UpdateLocationView`
**Path:** `app/locations/views/update_location_view.dart`

**Structure:**
```dart
Scaffold(
  appBar: AppBar with back button and title,
  body: Obx(() {
    if (!controller.isInitialized) return CircularProgressIndicator;
    if (controller.currentLocation == null) return Error message;
    
    return LocationForm(
      currentLocation: controller.currentLocation.value,
      isCreation: false,
      onSaved: controller.onLocationSaved,
      showNameStep: true,
    );
  }),
)
```

### 2.3 Binding: `UpdateLocationBinding`
**Path:** `app/locations/bindings/update_location_binding.dart`

**Injects:**
- `UpdateLocationController`

### 2.4 Route
**Pattern:** `/profiles/:profile_id/locations/:location_id/edit`
**Constant:** `Routes.updateLocation`

---

## 3. Routing Configuration

### 3.1 Add Routes to `app_routes.dart`
```dart
abstract class Routes {
  // ... existing routes
  static const updateProfile = '/profiles/:profile_id/edit';
  static const updateLocation = '/profiles/:profile_id/locations/:location_id/edit';
}
```

### 3.2 Add Pages to `app_pages.dart`
```dart
static final routes = [
  // ... existing routes
  
  GetPage(
    name: Routes.updateProfile,
    page: () => UpdateProfileView(),
    binding: UpdateProfileBinding(),
    middlewares: [AuthGuardMiddleware()],
  ),
  
  GetPage(
    name: Routes.updateLocation,
    page: () => UpdateLocationView(),
    binding: UpdateLocationBinding(),
    middlewares: [AuthGuardMiddleware()],
  ),
];
```

---

## 4. Data Flow Pattern

### Profile Update Flow:
1. User navigates to `/profiles/:profile_id/edit`
2. `UpdateProfileController` loads profile from `user.profiles` or `user.locationsWorked`
3. `ProfileForm` displays with existing data (`isCreation: false`)
4. User edits and saves
5. `onProfileSaved` callback triggered
6. User data refreshed via `authController.refreshUser()`
7. Navigate back with `Get.back()`

### Location Update Flow:
1. User navigates to `/profiles/:profile_id/locations/:location_id/edit`
2. `UpdateLocationController` loads both profile and location from `user.locationsWorked`
3. `LocationForm` displays with existing data (`isCreation: false`)
4. User edits and saves
5. `onLocationSaved` callback triggered
6. User data refreshed via `authController.refreshUser()`
7. Navigate back with `Get.back()`

---

## 5. Key Differences from Setup Flow

| Aspect | Setup Flow | Update Views |
|--------|-----------|--------------|
| Purpose | Initial configuration | Update existing data |
| Navigation | Multi-step wizard | Single form view |
| Stepper | Yes (AppStepper) | No stepper |
| Steps | Profile → Location → Services → Availability → Members | Single form per view |
| isCreation | true | false |
| Scope Selection | Creates and sets scope | Maintains existing scope |
| Navigation After Save | Next step or home | Back to previous screen |

---

## 6. Additional Considerations

### 6.1 Similar Patterns for Other Steps
Following the same pattern, these views could also be created:
- `UpdateServicesView` - `/profiles/:profile_id/locations/:location_id/services/edit`
- `UpdateAvailabilityView` - `/profiles/:profile_id/locations/:location_id/availability/edit`
- `UpdateMembersView` - `/profiles/:profile_id/locations/:location_id/members/edit`

### 6.2 Permissions
Consider checking if user has permission to edit:
- For profiles: User must own the profile OR be admin/super-admin
- For locations: User must have manager/admin role at that location

### 6.3 Error Handling
- Profile/Location not found → Show error message
- No permission → Redirect or show access denied
- Network errors → Show retry option

---

## 7. Files to Create

```
apps/bartoo-business/lib/app/
├── profiles/
│   ├── controllers/
│   │   └── update_profile_controller.dart ✓ (created)
│   ├── views/
│   │   └── update_profile_view.dart
│   └── bindings/
│       └── update_profile_binding.dart
├── locations/
│   ├── controllers/
│   │   └── update_location_controller.dart
│   ├── views/
│   │   └── update_location_view.dart
│   └── bindings/
│       └── update_location_binding.dart
└── routes/
    ├── app_routes.dart (modify)
    └── app_pages.dart (modify)
```

---

## 8. Implementation Checklist

- [x] Create `UpdateProfileController`
- [x] Create `UpdateProfileView`
- [x] Create `UpdateProfileBinding`
- [x] Create `UpdateLocationController`
- [x] Create `UpdateLocationView`
- [x] Create `UpdateLocationBinding`
- [x] Add routes to `app_routes.dart`
- [x] Add pages to `app_pages.dart`
- [ ] Test profile update flow
- [ ] Test location update flow

---

## 9. Implementation Complete ✓

All files have been successfully created and integrated:

### Created Files:
1. ✅ `app/profiles/controllers/update_profile_controller.dart`
2. ✅ `app/profiles/views/update_profile_view.dart`
3. ✅ `app/profiles/bindings/update_profile_binding.dart`
4. ✅ `app/locations/controllers/update_location_controller.dart`
5. ✅ `app/locations/views/update_location_view.dart`
6. ✅ `app/locations/bindings/update_location_binding.dart`

### Modified Files:
1. ✅ `app/routes/app_routes.dart` - Added route constants
2. ✅ `app/routes/app_pages.dart` - Added GetPage configurations

### Routes Available:
- `/profiles/:profile_id/edit` - Update profile
- `/profiles/:profile_id/locations/:location_id/edit` - Update location

### Usage Example:
```dart
// Navigate to update profile
Get.toNamed('/profiles/${profileId}/edit');

// Navigate to update location
Get.toNamed('/profiles/${profileId}/locations/${locationId}/edit');
```

All implementations follow GetX patterns with proper dependency injection and error handling.

---

## Questions to Validate

1. **Navigation after save:** Should it go back to previous screen or to a specific view?
2. **Permissions:** Should we add permission checks in controllers?
3. **Additional views:** Do we need similar views for Services, Availability, and Members steps?
4. **Error states:** What should happen if profile/location is not found?
5. **Scope selection:** Should updating trigger scope selection or just refresh data?
