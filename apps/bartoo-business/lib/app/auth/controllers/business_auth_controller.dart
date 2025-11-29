import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/data/models/member_model.dart';
import 'package:core/modules/auth/controllers/base_auth_controller.dart';
import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:get/get.dart';
import 'package:utils/log.dart';

/// Business app specific auth controller implementation
class BusinessAuthController extends BaseAuthController {
  // Business-specific properties
  Rx<BussinessScope?> selectedScope = Rx<BussinessScope?>(null);
  Rx<MemberModel?> pendingInvitation = Rx<MemberModel?>(null);

  /// Sets the default business scope for the authenticated user.
  ///
  /// This method determines which business context (profile or location) the user
  /// should operate under. It follows a priority order:
  /// 1. Preferred scope (if provided and valid)
  /// 2. Stored preferred scope from previous session
  /// 3. First available profile
  /// 4. First available location where user works
  ///
  /// **Parameters:**
  /// - [user]: The user model to set scope for. If null, uses current authenticated user.
  /// - [preferredScope]: Optional scope to prioritize. Can be [ProfileScope] or [LocationMemberScope].
  ///
  /// **Returns:**
  /// - [BussinessScope?]: The selected scope, or null if no valid scope found.
  ///
  /// **Example:**
  /// ```dart
  /// // Set scope with preferred profile
  /// final scope = await setAuthDefaultScope(
  ///   user: currentUser,
  ///   preferredScope: ProfileScope(myProfile),
  /// );
  ///
  /// // Auto-detect scope from stored preference or available scopes
  /// final scope = await setAuthDefaultScope(user: currentUser);
  /// ```
  Future<BussinessScope?> setAuthDefaultScope({
    UserModel? user,
    BussinessScope? preferredScope,
  }) async {
    // If no user provided, try to use currently authenticated user
    if (user == null) {
      if (this.user.value != null) {
        user = this.user.value!;
      } else {
        // No user available, clear scope and return
        setSelectedScope(null);
        return null;
      }
    }

    // Retrieve previously stored scope preference from local storage
    var storedPreferredScope = await authRepository.getSelectedScope();
    BussinessScope? scope;

    // If no preferred scope provided but one exists in storage, use it
    if (storedPreferredScope != null && preferredScope == null) {
      preferredScope = storedPreferredScope;
    }

    // Validate and set preferred scope if provided
    if (preferredScope != null) {
      // Handle ProfileScope: verify the profile still exists in user's profiles
      if (preferredScope is ProfileScope && user.profiles != null) {
        var preferredProfile = user.profiles!.firstWhereOrNull(
          (p) => p.id == (preferredScope as ProfileScope).profile.id,
        );
        if (preferredProfile != null) scope = ProfileScope(preferredProfile);
      }
      // Handle LocationMemberScope: verify the location still exists in user's locations
      else if (preferredScope is LocationMemberScope &&
          user.locationsWorked != null) {
        var preferredLocation = user.locationsWorked!.firstWhereOrNull(
          (l) =>
              l.id == (preferredScope as LocationMemberScope).locationMember.id,
        );
        if (preferredLocation != null) {
          scope = LocationMemberScope(preferredLocation);
        }
      }
    }

    // Fallback logic: If no valid preferred scope found, use first available
    // Priority: Profiles > Locations
    if (scope == null) {
      // Firstly use first location where user is a member
      if (user.locationsWorked != null && user.locationsWorked!.isNotEmpty) {
        scope = LocationMemberScope(user.locationsWorked!.first);
      }
      // In no locations, ry to use user's owned profiles
      else if (user.profiles != null && user.profiles!.isNotEmpty) {
        scope = ProfileScope(user.profiles!.first);
      }
    }

    // Persist and apply the selected scope
    setSelectedScope(scope);

    return scope;
  }

  /// Selects a specific location member scope for the authenticated user.
  ///
  /// This method finds and sets the scope to a specific location where the user
  /// is a member, under a given profile/organization.
  ///
  /// **Parameters:**
  /// - [profileId]: The ID of the profile/organization that owns the location.
  /// - [locationId]: The ID of the location to select as the active scope.
  ///
  /// **Throws:**
  /// - [Exception]: If no user is authenticated or user has no locations.
  /// - [Exception]: If the specified location is not found for the user under the given profile.
  ///
  /// **Example:**
  /// ```dart
  /// // Select a specific location as active scope
  /// authController.selectLocationMemberScope(
  ///   'fcfe87f2-1f07-4e04-b333-ac56d54bd151',
  ///   '093cf315-bac7-4802-abdb-674925f04628',
  /// );
  /// ```
  void selectLocationMemberScope(String profileId, [String? locationId]) {
    if (user.value == null || user.value!.locationsWorked == null) {
      throw Exception('No user or locations available to select from');
    }

    Log('ProfileId: $profileId - LocationId: $locationId');
    Log('Locations Worked for user: ${user.value?.toJson()}');

    var locationMember = user.value!.locationsWorked!.firstWhereOrNull(
      (loc) =>
          locationId != null
              ? loc.location?.id == locationId &&
                  loc.organization?.id == profileId
              : loc.organization?.id == profileId && loc.location == null,
    );

    if (locationMember == null) {
      throw Exception(
        'Location with id $locationId under profile $profileId not found for user',
      );
    }

    setSelectedScope(LocationMemberScope(locationMember));
  }

  /// Sets the selected business scope and persists it.
  ///
  /// This method updates the reactive selected scope value and triggers
  /// business-specific logic through [onSelectedScopeSet].
  ///
  /// **Parameters:**
  /// - [newScope]: The new scope to set. Can be [ProfileScope], [LocationMemberScope], or null.
  ///
  /// **Example:**
  /// ```dart
  /// // Set a profile scope
  /// authController.setSelectedScope(ProfileScope(myProfile));
  ///
  /// // Clear the scope
  /// authController.setSelectedScope(null);
  /// ```
  void setSelectedScope(BussinessScope? newScope) {
    selectedScope.value = newScope;
    onSelectedScopeSet(newScope);
  }

  /// Callback invoked when the selected scope is set.
  ///
  /// This method handles business-specific logic when a scope changes,
  /// including persisting the scope to local storage for future sessions.
  ///
  /// **Parameters:**
  /// - [scope]: The newly selected scope to persist and process.
  void onSelectedScopeSet(BussinessScope? scope) {
    authRepository.setSelectedScope(scope);
  }

  void setPendingInvitation(MemberModel? invitation) {
    pendingInvitation.value = invitation;
    authRepository.setPendingInvitation(invitation);
  }

  @override
  void onSignout() {
    super.onSignout();
    // Business-specific cleanup when user signs out
    selectedScope.value = null;
    Get.offAllNamed(Routes.home);
  }
}
