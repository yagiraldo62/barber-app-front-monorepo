import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/data/models/profile_model.dart';
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

    await authController.setAuthDefaultScope(user: user);

    // Redirect user after login
    await onLoginRedirection(user);
  }

  @override
  Future<void> onLoginRedirection(UserModel? user) async {
    if (user == null && authController.user.value == null) {
      Get.offAndToNamed(dotenv.env['HOME_ROUTE'] ?? Routes.SPLASH);
      return;
    }

    BussinessScope? selectedScope = authController.selectedScope.value;

    // Always enforce phone verification first if user exists
    if (user?.isPhoneVerified != true) {
      Get.offAndToNamed(
        dotenv.env['VERIFY_PHONE_ROUTE'] ?? Routes.VERIFY_PHONE,
      );
      return;
    }

    // apply redirection logic based on user state
    // If user is not authenticated, redirect to login
    if (user?.isFirstLogin == true) {
      // Redirect to introduction screen for first-time users
      Get.offAndToNamed(dotenv.env['INTRODUCTION_ROUTE'] ?? Routes.INTRO);
      return;
    }

    if (selectedScope != null) {
      switch (selectedScope) {
        case ProfileScope(:final profile):
          // Redirect to profile home if user has profiles
          if (profile.type == ProfileType.organization) {
            if (profile.locations != null && profile.locations!.isNotEmpty) {
              // Redirect to location home if profile has locations
              Get.offAndToNamed(
                dotenv.env['LOCATION_HOME_ROUTE'] ??
                    Routes.SETUP_PROFILE
                        .replaceFirst(':profile_id', profile.id!)
                        .replaceFirst(
                          ':location_id',
                          profile.locations!.first.id!,
                        ),
              );
            } else {
              // TODO : ERROR
            }
          }
          break;
        case LocationMemberScope(:final locationMember):
          break;
        default:
          // Fallback to regular home screen
          Get.offAndToNamed(dotenv.env['HOME_ROUTE'] ?? Routes.SPLASH);
      }
      // Redirect to profile home if user has profiles
      Get.offAndToNamed(dotenv.env['ARTIST_HOME_ROUTE'] ?? Routes.ARTIST_HOME);
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
    BussinessScope? selectedScope,
  ) async {
    // set user and selected scope in auth controller AFTER redirection
    authController.setUser(user);
    authController.setSelectedScope(selectedScope);

    await onLoginRedirection(user);
  }
}
