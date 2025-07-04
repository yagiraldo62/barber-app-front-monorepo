import 'package:core/data/models/artists/artist_model.dart';
import 'package:core/data/models/user/user_model.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:get/get.dart';

/// Abstract base class for auth controllers
/// Apps should extend this class and implement their own business logic
abstract class BaseAuthController extends GetxController {
  final AuthRepository authRepository = Get.find<AuthRepository>();

  Rx<UserModel?> user = Rx<UserModel?>(null);
  Rx<bool> validating = false.obs;

  void setUser(UserModel? newUser) {
    user.value = newUser;
    onUserSet(newUser);
  }

  /// Called when user is set - apps can override for custom logic
  void onUserSet(UserModel? user) {
    // Override in app implementations for custom behavior
  }

  void signout() {
    authRepository.signout();
    setUser(null);
    onSignout();
  }

  /// Called when user signs out - apps can override for custom logic
  void onSignout() {
    // Override in app implementations if needed
  }

  @override
  void onClose() {
    super.onClose();
    super.dispose();
  }
}

/// Legacy AuthController for backward compatibility
/// @deprecated Use BaseAuthController and create app-specific implementations
@Deprecated('Use BaseAuthController and create app-specific implementations')
class AuthController extends BaseAuthController {
  // Maintains backward compatibility
}
