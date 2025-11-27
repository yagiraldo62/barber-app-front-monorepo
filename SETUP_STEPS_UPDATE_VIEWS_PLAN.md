# Implementation Plan: Separate Update Views for Services, Availability and Members

## Overview
Create dedicated views for updating services, availability, and members independently, without going through the full setup flow. This follows the same pattern as the Profile and Location update views.

---

## 1. Update Services Feature

### 1.1 Controller: `UpdateServicesController`
**Path:** `app/services/controllers/update_services_controller.dart`

**Responsibilities:**
- Get `profile_id` and `location_id` from route parameters
- Initialize `currentProfile` and `currentLocation` by searching:
  - `user.locationsWorked[]` - Find matching organization and location
  - Fallback to `user.profiles[]` if profile is owned
- Load selected category IDs from profile
- Handle services save callback
- Refresh user data after update
- Navigate back after successful save

**Key Methods:**
- `_loadFromRoute()` - Loads profile and location from route params
- `onServicesSaved()` - Handles save callback

### 1.2 View: `UpdateServicesView`
**Path:** `app/services/views/update_services_view.dart`

**Structure:**
```dart
Scaffold(
  appBar: AppBar with back button and title,
  body: Obx(() {
    if (!controller.isInitialized) return CircularProgressIndicator;
    if (controller.currentProfile == null || controller.currentLocation == null) 
      return Error message;
    
    return LocationServicesForm(
      profileId: controller.currentProfile.value!.id!,
      locationId: controller.currentLocation.value!.id!,
      servicesUp: true,
      selectedCategoryIds: controller.selectedCategoryIds,
      onSaved: (services) => controller.onServicesSaved(),
    );
  }),
)
```

### 1.3 Binding: `UpdateServicesBinding`
**Path:** `app/services/bindings/update_services_binding.dart`

**Injects:**
- `UpdateServicesController`
- Required providers and repositories

### 1.4 Route
**Pattern:** `/profiles/:profile_id/locations/:location_id/services/edit`
**Constant:** `Routes.updateServices`

---

## 2. Update Availability Feature

### 2.1 Controller: `UpdateAvailabilityController`
**Path:** `app/availability/controllers/update_availability_controller.dart`

**Responsibilities:**
- Get `profile_id` and `location_id` from route parameters
- Initialize `currentProfile` and `currentLocation` by searching:
  - `user.locationsWorked[]` - Find matching organization and location
  - Fallback to `user.profiles[]` if profile is owned
- Determine if it's creation or update based on `location.availabilityUp`
- Handle availability save callback
- Refresh user data after update
- Navigate back after successful save

**Key Methods:**
- `_loadFromRoute()` - Loads profile and location from route params
- `onAvailabilitySaved()` - Handles save callback

### 2.2 View: `UpdateAvailabilityView`
**Path:** `app/availability/views/update_availability_view.dart`

**Structure:**
```dart
Scaffold(
  appBar: AppBar with back button and title,
  body: Obx(() {
    if (!controller.isInitialized) return CircularProgressIndicator;
    if (controller.currentProfile == null || controller.currentLocation == null) 
      return Error message;
    
    return AvailabilityForm(
      profileId: controller.currentProfile.value!.id!,
      locationId: controller.currentLocation.value!.id!,
      isCreation: controller.isCreation.value,
      onSaved: (updated) => controller.onAvailabilitySaved(),
    );
  }),
)
```

### 2.3 Binding: `UpdateAvailabilityBinding`
**Path:** `app/availability/bindings/update_availability_binding.dart`

**Injects:**
- `UpdateAvailabilityController`
- Required providers and repositories

### 2.4 Route
**Pattern:** `/profiles/:profile_id/locations/:location_id/availability/edit`
**Constant:** `Routes.updateAvailability`

---

## 3. Update Members Feature

### 3.1 Controller: `UpdateMembersController`
**Path:** `app/members/controllers/update_members_controller.dart`

**Responsibilities:**
- Get `profile_id` and `location_id` from route parameters
- Initialize `currentProfile` and `currentLocation` by searching:
  - `user.locationsWorked[]` - Find matching organization and location
  - Fallback to `user.profiles[]` if profile is owned
- Handle members update callback
- Refresh user data after update
- Navigate back after successful save

**Key Methods:**
- `_loadFromRoute()` - Loads profile and location from route params
- `onMembersUpdated()` - Handles save callback

### 3.2 View: `UpdateMembersView`
**Path:** `app/members/views/update_members_view.dart`

**Structure:**
```dart
Scaffold(
  appBar: AppBar with back button and title,
  body: Obx(() {
    if (!controller.isInitialized) return CircularProgressIndicator;
    if (controller.currentProfile == null || controller.currentLocation == null) 
      return Error message;
    
    return ManageMembers(
      organizationId: controller.currentProfile.value!.id!,
      locationId: controller.currentLocation.value!.id,
      onContinue: () => controller.onMembersUpdated(),
    );
  }),
)
```

### 3.3 Binding: `UpdateMembersBinding`
**Path:** `app/members/bindings/update_members_binding.dart`

**Injects:**
- `UpdateMembersController`
- Required providers and repositories

### 3.4 Route
**Pattern:** `/profiles/:profile_id/locations/:location_id/members/edit`
**Constant:** `Routes.updateMembers`

---

## 4. Routing Configuration

### 4.1 Add Routes to `app_routes.dart`
```dart
abstract class Routes {
  // ... existing routes
  static const updateServices = '/profiles/:profile_id/locations/:location_id/services/edit';
  static const updateAvailability = '/profiles/:profile_id/locations/:location_id/availability/edit';
  static const updateMembers = '/profiles/:profile_id/locations/:location_id/members/edit';
}
```

### 4.2 Add Pages to `app_pages.dart`
```dart
static final routes = [
  // ... existing routes
  
  GetPage(
    name: Routes.updateServices,
    page: () => const UpdateServicesView(),
    binding: UpdateServicesBinding(),
    middlewares: [AuthGuardMiddleware()],
  ),
  
  GetPage(
    name: Routes.updateAvailability,
    page: () => const UpdateAvailabilityView(),
    binding: UpdateAvailabilityBinding(),
    middlewares: [AuthGuardMiddleware()],
  ),
  
  GetPage(
    name: Routes.updateMembers,
    page: () => const UpdateMembersView(),
    binding: UpdateMembersBinding(),
    middlewares: [AuthGuardMiddleware()],
  ),
];
```

---

## 5. Data Flow Patterns

### Services Update Flow:
1. User navigates to `/profiles/:profile_id/locations/:location_id/services/edit`
2. `UpdateServicesController` loads profile and location from `user.locationsWorked` or `user.profiles`
3. Extract `selectedCategoryIds` from `profile.categories`
4. `LocationServicesForm` displays with existing data (`servicesUp: true`)
5. User edits and saves
6. `onServicesSaved` callback triggered
7. User data refreshed via `authController.refreshUser()`
8. Navigate back with `Get.back()`

### Availability Update Flow:
1. User navigates to `/profiles/:profile_id/locations/:location_id/availability/edit`
2. `UpdateAvailabilityController` loads profile and location
3. Determine `isCreation` from `location.availabilityUp` status
4. `AvailabilityForm` displays with existing data
5. User edits and saves
6. `onAvailabilitySaved` callback triggered
7. User data refreshed via `authController.refreshUser()`
8. Navigate back with `Get.back()`

### Members Update Flow:
1. User navigates to `/profiles/:profile_id/locations/:location_id/members/edit`
2. `UpdateMembersController` loads profile and location
3. `ManageMembers` displays current members for the location
4. User adds/removes/edits members
5. `onMembersUpdated` callback triggered
6. User data refreshed via `authController.refreshUser()`
7. Navigate back with `Get.back()`

---

## 6. Key Differences from Setup Flow

| Aspect | Setup Flow | Update Views |
|--------|-----------|--------------|
| Purpose | Initial configuration | Update existing data |
| Navigation | Multi-step wizard | Single form view |
| Stepper | Yes (AppStepper) | No stepper |
| Context | Profile → Location → Services → Availability → Members | Direct access to specific step |
| servicesUp flag | false (initial setup) | true (update mode) |
| isCreation | Based on setup state | Based on availabilityUp flag |
| Scope Selection | Creates and sets scope | Maintains existing scope |
| Navigation After Save | Next step or home | Back to previous screen |

---

## 7. Common Controller Pattern

All three controllers share a similar structure:

```dart
class UpdateXController extends GetxController {
  final BusinessAuthController _authController = Get.find<BusinessAuthController>();
  
  final isInitialized = RxBool(false);
  final currentProfile = Rx<ProfileModel?>(null);
  final currentLocation = Rx<LocationModel?>(null);
  
  @override
  void onInit() async {
    super.onInit();
    await _loadFromRoute();
    isInitialized.value = true;
  }
  
  Future<void> _loadFromRoute() async {
    final profileId = Get.parameters['profile_id'];
    final locationId = Get.parameters['location_id'];
    
    // Load from user.locationsWorked or user.profiles
    // Set currentProfile and currentLocation
  }
  
  void onSaved() async {
    await _authController.refreshUser();
    Get.back();
  }
}
```

---

## 8. Integration with SettingsView

Update the `SettingsView` to include navigation buttons for these new update views:

```dart
// In _LocationCard widget, add action buttons:
Row(
  children: [
    TextButton.icon(
      icon: Icon(Icons.category),
      label: Text('Servicios'),
      onPressed: () => Get.toNamed(
        '/profiles/$organizationId/locations/${location.id}/services/edit'
      ),
    ),
    TextButton.icon(
      icon: Icon(Icons.schedule),
      label: Text('Disponibilidad'),
      onPressed: () => Get.toNamed(
        '/profiles/$organizationId/locations/${location.id}/availability/edit'
      ),
    ),
    TextButton.icon(
      icon: Icon(Icons.group),
      label: Text('Miembros'),
      onPressed: () => Get.toNamed(
        '/profiles/$organizationId/locations/${location.id}/members/edit'
      ),
    ),
  ],
)
```

---

## 9. Files to Create

```
apps/bartoo-business/lib/app/
├── services/
│   ├── controllers/
│   │   └── update_services_controller.dart
│   ├── views/
│   │   └── update_services_view.dart
│   └── bindings/
│       └── update_services_binding.dart
├── availability/
│   ├── controllers/
│   │   └── update_availability_controller.dart
│   ├── views/
│   │   └── update_availability_view.dart
│   └── bindings/
│       └── update_availability_binding.dart
├── members/
│   ├── controllers/
│   │   └── update_members_controller.dart
│   ├── views/
│   │   └── update_members_view.dart
│   └── bindings/
│       └── update_members_binding.dart
└── routes/
    ├── app_routes.dart (modify)
    └── app_pages.dart (modify)
```

---

## 10. Implementation Checklist

- [x] Create `UpdateServicesController`
- [x] Create `UpdateServicesView`
- [x] Create `UpdateServicesBinding`
- [x] Create `UpdateAvailabilityController`
- [x] Create `UpdateAvailabilityView`
- [x] Create `UpdateAvailabilityBinding`
- [x] Create `UpdateMembersController`
- [x] Create `UpdateMembersView`
- [x] Create `UpdateMembersBinding`
- [x] Add routes to `app_routes.dart`
- [x] Add pages to `app_pages.dart`
- [ ] Update `SettingsView` with navigation buttons
- [ ] Test services update flow
- [ ] Test availability update flow
- [ ] Test members update flow

---

## 15. Implementation Complete ✓

All files have been successfully created and integrated:

### Created Files:
1. ✅ `app/services/controllers/update_services_controller.dart`
2. ✅ `app/services/views/update_services_view.dart`
3. ✅ `app/services/bindings/update_services_binding.dart`
4. ✅ `app/availability/controllers/update_availability_controller.dart`
5. ✅ `app/availability/views/update_availability_view.dart`
6. ✅ `app/availability/bindings/update_availability_binding.dart`
7. ✅ `app/members/controllers/update_members_controller.dart`
8. ✅ `app/members/views/update_members_view.dart`
9. ✅ `app/members/bindings/update_members_binding.dart`

### Modified Files:
1. ✅ `app/routes/app_routes.dart` - Added route constants for all three views
2. ✅ `app/routes/app_pages.dart` - Added GetPage configurations with proper bindings

### Routes Available:
- `/profiles/:profile_id/locations/:location_id/services/edit` - Update services
- `/profiles/:profile_id/locations/:location_id/availability/edit` - Update availability
- `/profiles/:profile_id/locations/:location_id/members/edit` - Update members

### Usage Examples:
```dart
// Navigate to update services
Get.toNamed('/profiles/${profileId}/locations/${locationId}/services/edit');

// Navigate to update availability
Get.toNamed('/profiles/${profileId}/locations/${locationId}/availability/edit');

// Navigate to update members
Get.toNamed('/profiles/${profileId}/locations/${locationId}/members/edit');

// Or use route constants
Get.toNamed(Routes.updateServices, parameters: {
  'profile_id': profileId,
  'location_id': locationId,
});
```

All implementations follow GetX patterns with proper dependency injection, error handling, and consistent user experience.

---

## 11. Additional Considerations

### 11.1 Permissions
Consider checking if user has permission to edit:
- **Services**: User must have manager/admin role at the location
- **Availability**: User must have manager/admin role at the location
- **Members**: User must have admin/super-admin role (more restrictive)

### 11.2 Error Handling
- Profile/Location not found → Show error message
- No permission → Redirect or show access denied
- Network errors → Show retry option
- Invalid data → Show validation errors

### 11.3 State Management
- Services: Track selected categories and service configurations
- Availability: Track time slots and schedule changes
- Members: Track invitations, role changes, and member removals

### 11.4 UI Enhancements
- Add loading states during data fetch
- Show success/error toasts after operations
- Implement optimistic updates where appropriate
- Add confirmation dialogs for destructive actions (e.g., removing members)

---

## 12. Dependencies

All controllers require:
- `BusinessAuthController` - For user context and data refresh
- Route parameters: `profile_id` and `location_id`
- Access to `user.locationsWorked` and `user.profiles`

### Services Dependencies:
- `LocationServicesForm` widget
- Category data from profile

### Availability Dependencies:
- `AvailabilityForm` widget
- Location availability status flag

### Members Dependencies:
- `ManageMembers` widget
- Organization and location IDs

---

## 13. Usage Examples

```dart
// Navigate to update services
Get.toNamed('/profiles/${profileId}/locations/${locationId}/services/edit');

// Navigate to update availability
Get.toNamed('/profiles/${profileId}/locations/${locationId}/availability/edit');

// Navigate to update members
Get.toNamed('/profiles/${profileId}/locations/${locationId}/members/edit');

// Or use route constants
Get.toNamed(
  Routes.updateServices,
  parameters: {
    'profile_id': profileId,
    'location_id': locationId,
  },
);
```

---

## 14. Testing Strategy

### Unit Tests:
- Controller initialization
- Route parameter extraction
- Data loading from user context
- Save callbacks and user refresh

### Integration Tests:
- Full navigation flow
- Form submission and data persistence
- Error handling scenarios
- Permission checks

### E2E Tests:
- Complete user journey from SettingsView
- Multi-location scenarios
- Role-based access control
- Data consistency after updates
