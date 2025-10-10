import 'package:core/modules/auth/classes/auth_state.dart';
import 'package:core/modules/auth/interfaces/auth_callbacks.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:get/get.dart';

/// Abstract base class for guard controllers
/// Apps should extend this class and implement their own validation logic
abstract class BaseGuardController extends GetxController {
  final AuthRepository authRepository = Get.find<AuthRepository>();

  /// Must be implemented by each app to provide their specific auth callbacks
  AuthCallbacks get authCallbacks;

  void validateAuthState() async {
    AuthState data = await authRepository.getAuthState();
    await validate(data);
  }

  Future<void> validate(AuthState data) async {
    await authCallbacks.onAuthValidation(data.user, data.selectedScope);
  }

  @override
  void onReady() {
    super.onReady();
    validateAuthState();
  }
}
