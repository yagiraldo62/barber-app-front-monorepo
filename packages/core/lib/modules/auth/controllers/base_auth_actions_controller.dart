import 'package:core/data/models/user/user_model.dart';
import 'package:core/modules/auth/interfaces/auth_callbacks.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:utils/is_valid_jwt.dart';
import 'package:get/get.dart';

/// Abstract base class for auth actions controllers
/// Apps should extend this class and implement their own business logic
abstract class BaseAuthActionsController extends GetxController {
  final AuthRepository authRepository = Get.find<AuthRepository>();

  /// Must be implemented by each app to provide their specific auth callbacks
  AuthCallbacks get authCallbacks;

  void signInWithFacebook() {
    authRepository.signInWithFacebook();
  }

  void signinWithToken(String token) async {
    try {
      if (isValidJWT(token)) {
        await authRepository.setAuthToken(token);
        UserModel? user = await authRepository.fetchAuthData();
        if (user != null) await authCallbacks.onLogin(user);
      }
    } catch (e) {
      print('Error signing in with token: $e');
    }
  }

  /// Validates the user's authentication status
  Future<UserModel?> validateAuth() async {
    UserModel? user;
    String? token = await authRepository.getAuthToken();

    if (token != null && isValidJWT(token)) {
      user = await authRepository.getAuthUser();
    } else {
      authRepository.signout();
    }
    return user;
  }

  void validateAuthForFirstRedirection() async {
    UserModel? user = await validateAuth();
    authCallbacks.onLoginRedirection(user);
  }

  void signout() async {
    await authCallbacks.onLogout();
    authRepository.signout();
  }
}
