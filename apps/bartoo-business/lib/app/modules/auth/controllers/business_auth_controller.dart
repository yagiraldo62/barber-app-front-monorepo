import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:get/get.dart';

/// Business app specific auth controller implementation
class BusinessAuthController extends BaseAuthController {
  // Business-specific properties
  Rx<SelectedScope?> selectedScope = Rx<SelectedScope?>(null);

  Future<SelectedScope?> setAuthDefaultScope({
    UserModel? user,
    SelectedScope? preferredScope,
  }) async {
    if (user == null) {
      if (this.user.value != null) {
        user = this.user.value!;
      } else {
        setSelectedScope(null);
        return null;
      }
    }

    var storedPreferredScope = await authRepository.getSelectedScope();
    SelectedScope? scope;

    if (storedPreferredScope != null && preferredScope == null) {
      preferredScope = storedPreferredScope;
    }

    // If preferred scope is provided and valid, use it
    if (preferredScope != null) {
      if (preferredScope is ProfileScope && user.profiles != null) {
        var preferredProfile = user.profiles!.firstWhereOrNull(
          (p) => p.id == (preferredScope as ProfileScope).profile.id,
        );
        if (preferredProfile != null) scope = ProfileScope(preferredProfile);
      } else if (preferredScope is LocationMemberScope &&
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

    // Fallback logic: choose first available scope
    // If user has profiles, use the first one
    // If not, check locations worked
    if (user.profiles != null && user.profiles!.isNotEmpty) {
      scope = ProfileScope(user.profiles!.first);
    } else if (user.locationsWorked != null &&
        user.locationsWorked!.isNotEmpty) {
      scope = LocationMemberScope(user.locationsWorked!.first);
    }

    setSelectedScope(scope);

    return scope;
  }

  void setSelectedScope(SelectedScope? newScope) {
    selectedScope.value = newScope;
    onSelectedScopeSet(newScope);
  }

  /// Called when selected scope is set - business-specific logic
  void onSelectedScopeSet(SelectedScope? scope) {
    authRepository.setSelectedScope(scope);
  }

  @override
  void onSignout() {
    super.onSignout();
    // Business-specific cleanup when user signs out
    selectedScope.value = null;
  }
}
