import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:get/get.dart';

/// Business app specific auth controller implementation
class BusinessAuthController extends BaseAuthController {
  // Business-specific properties
  Rx<BussinessScope?> selectedScope = Rx<BussinessScope?>(null);

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
      // First try to use user's owned profiles
      if (user.profiles != null && user.profiles!.isNotEmpty) {
        scope = ProfileScope(user.profiles!.first);
      }
      // If no profiles, use first location where user is a member
      else if (user.locationsWorked != null &&
          user.locationsWorked!.isNotEmpty) {
        scope = LocationMemberScope(user.locationsWorked!.first);
      }
    }

    // Persist and apply the selected scope
    setSelectedScope(scope);

    return scope;
  }

  void setSelectedScope(BussinessScope? newScope) {
    selectedScope.value = newScope;
    onSelectedScopeSet(newScope);
  }

  /// Called when selected scope is set - business-specific logic
  void onSelectedScopeSet(BussinessScope? scope) {
    authRepository.setSelectedScope(scope);
  }

  @override
  void onSignout() {
    super.onSignout();
    // Business-specific cleanup when user signs out
    selectedScope.value = null;
  }
}
