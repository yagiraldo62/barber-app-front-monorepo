import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
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
    authRepository.setAuthUser(user);
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

  Future<UserModel> refreshUser() async {
    validating.value = true;
    UserModel? currentUser = await authRepository.getAuthUser();
    setUser(currentUser);
    validating.value = false;

    return currentUser!;
  }

  @override
  void onClose() {
    super.onClose();
    super.dispose();
  }
}
