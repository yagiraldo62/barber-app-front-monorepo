import 'package:core/modules/auth/controllers/base_guard_controller.dart';
import 'package:core/modules/auth/interfaces/auth_callbacks.dart';
import 'package:bartoo/app/auth/controllers/business_auth_callbacks.dart';
import 'package:core/modules/auth/classes/auth_state.dart';
import 'package:utils/log.dart';

/// Business app specific auth guard controller
class BusinessAuthGuardController extends BaseGuardController {
  late final AuthCallbacks _authCallbacks;

  BusinessAuthGuardController() {
    _authCallbacks = BusinessAuthCallbacks();
  }

  @override
  AuthCallbacks get authCallbacks => _authCallbacks;

  @override
  Future<void> validate(AuthState authState) async {
    super.validate(authState);

    Log('BusinessAuthGuardController: validate - ${authState.toJson()}');
    // Auth guard specific logic - redirect if user IS authenticated
    _authCallbacks.onAuthValidation(authState.user, authState.selectedScope);
  }
}
