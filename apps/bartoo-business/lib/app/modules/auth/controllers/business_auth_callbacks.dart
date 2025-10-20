import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/data/models/location_member_model.dart';
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

    BussinessScope? selectedScope = authController.selectedScope.value;

    if (selectedScope != null) {
      switch (selectedScope) {
        case ProfileScope(:final profile):
          // Redirect to profile home if user has profiles
          if (profile.type == ProfileType.organization) {
            if (profile.locations?.isEmpty == true) {
              // Redirect to setup location if organization profile has no locations
              Get.offAndToNamed(
                Routes.SETUP_PROFILE.replaceFirst(':profile_id', profile.id!),
              );
            } else if (profile.locations?.isNotEmpty == true &&
                (profile.locations?.first.servicesUp == false ||
                    profile.locations?.first.availabilityUp == false)) {
              // Redirect to profile home if organization profile has locations
              Get.offAndToNamed(
                Routes.SETUP_PROFILE_LOCATION
                    .replaceFirst(':profile_id', profile.id!)
                    .replaceFirst(':location_id', profile.locations!.first.id!),
              );
            } else {
              // Redirect to profile home if organization profile has locations
              Get.offAndToNamed(Routes.ARTIST_HOME);
            }
          } else if (profile.type == ProfileType.artist) {
            if (profile.independentArtist == true) {
              if (profile.servicesUp == false ||
                  profile.availabilityUp == false) {
                // Redirect to profile home if organization profile has locations
                Get.offAndToNamed(
                  Routes.SETUP_PROFILE.replaceFirst(':profile_id', profile.id!),
                );
              } else {
                // Redirect to profile home if organization profile has locations
                Get.offAndToNamed(Routes.ARTIST_HOME);
              }
            }
          }

          break;
        case LocationMemberScope(:final locationMember):
          Log(
            'Redirecting based on LocationMemberScope: ${locationMember.toJson()}',
          );
          if (locationMember.role == LocationMemberRole.superAdmin ||
              locationMember.role == LocationMemberRole.manager) {
            Log('User is admin of a location, checking setup status');
            if (locationMember.organization != null &&
                locationMember.location == null) {
              Log(
                'Redirecting to setup organization profile: ${locationMember.organization!.toJson()}',
              );
              Get.offNamed(
                Routes.SETUP_PROFILE.replaceAll(
                  ':profile_id',
                  locationMember.organization!.id!,
                ),
              );
            } else if (locationMember.location != null &&
                (locationMember.location!.servicesUp == false ||
                    locationMember.location!.availabilityUp == false)) {
              // Redirect to setup location if organization profile has no locations
              Get.offAndToNamed(
                Routes.SETUP_PROFILE_LOCATION
                    .replaceFirst(
                      ':profile_id',
                      locationMember.organization!.id!!,
                    )
                    .replaceFirst(':location_id', locationMember.location!.id!),
              );
            } else {
              // Redirect to location admin home if user is admin of a location
              Get.offAndToNamed(Routes.ARTIST_HOME);
            }
          } else {
            // Redirect to regular home screen if user is not admin of a location
            Get.offAndToNamed(Routes.ARTIST_HOME);
          }
          break;
        default:
          // Fallback to regular home screen
          Get.offAndToNamed(Routes.ARTIST_HOME);
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
    BussinessScope? selectedScope,
  ) async {
    // set user and selected scope in auth controller AFTER redirection
    authController.setUser(user);
    authController.setSelectedScope(selectedScope);

    await onLoginRedirection(user);
  }
}
