import 'package:core/modules/auth/controllers/base_guard_controller.dart';
import 'package:core/modules/auth/classes/auth_state.dart';
import 'package:core/modules/auth/interfaces/auth_callbacks.dart';
import 'package:bartoo/app/modules/auth/controllers/business_auth_callbacks.dart';

/// Business app specific guest guard controller
class BusinessGuestGuardController extends BaseGuardController {
  late final AuthCallbacks _authCallbacks;

  BusinessGuestGuardController() {
    _authCallbacks = BusinessAuthCallbacks();
  }

  @override
  AuthCallbacks get authCallbacks => _authCallbacks;

  @override
  Future<void> validate(AuthState authState) async {
    // Guest guard specific logic - redirect if user IS authenticated
    if (authState.user != null) {
      _authCallbacks.onAuthValidation(authState.user, authState.selectedScope);
    }
  }
}
