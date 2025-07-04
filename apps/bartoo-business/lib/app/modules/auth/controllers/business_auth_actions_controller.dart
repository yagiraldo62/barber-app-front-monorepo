import 'package:core/modules/auth/controllers/base_auth_actions_controller.dart';
import 'package:core/modules/auth/interfaces/auth_callbacks.dart';
import 'package:bartoo/app/modules/auth/controllers/business_auth_callbacks.dart';

/// Business app specific auth actions controller
class BusinessAuthActionsController extends BaseAuthActionsController {
  late final AuthCallbacks _authCallbacks;

  BusinessAuthActionsController() {
    _authCallbacks = BusinessAuthCallbacks();
  }

  @override
  AuthCallbacks get authCallbacks => _authCallbacks;
}
