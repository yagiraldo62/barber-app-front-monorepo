import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:core/modules/auth/interfaces/auth_callbacks.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:utils/geolocation/map_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:utils/log.dart';

/// Business app specific implementation of auth callbacks
class BusinessAuthCallbacks implements AuthCallbacks {
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();

  @override
  Future<void> onLogin(UserModel user) async {
    Log('Business app: onLogin - ${user.toJson()}');

    user = await setUserLocation(user);
    authController.setUser(user);

    // Set default scope after login
    await authController.setAuthDefaultScope(user: user);

    // Redirect user after login
    onLoginRedirection(user);
  }

  @override
  void onLoginRedirection(UserModel? user) {
    Log('Business app: onLoginRedirection - ${user?.toJson()}');

    // apply redirection logic based on user state
    // If user is not authenticated, redirect to login
    if (authController.user.value == null) {
      if (user?.isFirstLogin == true) {
        // Redirect to introduction screen for first-time users
        Get.offAndToNamed(dotenv.env['INTRODUCTION_ROUTE'] ?? Routes.INTRO);
      } else if (user?.profiles?.isNotEmpty ?? false) {
        // Redirect to profile home if user has profiles
        Get.offAndToNamed(
          dotenv.env['ARTIST_HOME_ROUTE'] ?? Routes.ARTIST_HOME,
        );
      } else {
        // Redirect to regular home screen
        Get.offAndToNamed(dotenv.env['HOME_ROUTE'] ?? Routes.SPLASH);
      }
    }
  }

  @override
  Future<void> onLogout() async {
    Log('Business app: onLogout - Cleaning up business-specific data');
    // Add any business-specific cleanup logic here
    // For example: clear cached data, reset app state, etc.
  }

  @override
  Future<UserModel> setUserLocation(UserModel user) async {
    Log('Business app: setUserLocation');
    Position? position = await getUserCurrentLocation();
    if (position != null) {
      user.location = position.toJson();
    }
    return user;
  }

  @override
  Future<void> onAuthValidation(
    UserModel? user,
    SelectedScope? selectedScope,
  ) async {
    onLoginRedirection(user);

    // set user and selected scope in auth controller AFTER redirection
    authController.setUser(user);
    authController.setSelectedScope(selectedScope);
  }
}
