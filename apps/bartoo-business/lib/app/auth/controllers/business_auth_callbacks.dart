import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/data/models/member_model.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:core/modules/auth/interfaces/auth_callbacks.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:utils/geolocation/map_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:utils/log.dart';

/// Business app specific implementation of auth callbacks
class BusinessAuthCallbacks implements AuthCallbacks {
  final String homeRoute = Routes.home;
  final List<String> setupRoutes = [
    Routes.intro,
    Routes.setupProfile,
    Routes.createProfile,
    Routes.setupProfileLocation,
    Routes.invitation,
  ];

  bool get isInHomeRoute {
    return Get.currentRoute == homeRoute;
  }

  bool get isInAuthTokenRoute {
    return Get.currentRoute.startsWith('/${Routes.authTokenRouteSegment}');
  }

  bool get isInSetupRoute {
    return setupRoutes.any((route) => Get.currentRoute.startsWith(route));
  }

  final AuthRepository authRepository = Get.find<AuthRepository>();
  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();

  @override
  Future<void> onLogin(UserModel user) async {
    Log('Business app: onLogin - ${user.toJson()}');

    user = await setUserLocation(user);
    authController.setUser(user);

    await authController.setAuthDefaultScope(user: user);

    MemberModel? pendingInvitation =
        await authRepository.getPendingInvitation();

    Log(
      'Setting pending invitation in auth controller: ${pendingInvitation?.toJson()}',
    );

    authController.setPendingInvitation(pendingInvitation);

    // Redirect user after login
    await onLoginRedirection(user);
  }

  @override
  guestRouteValidation(UserModel? user) {
    if (user == null && authController.user.value == null && !isInHomeRoute) {
      Get.offAndToNamed(homeRoute);
      return;
    }
  }

  @override
  authRoutesValidation(UserModel? user) {
    if (user == null && authController.user.value == null) {
      if (!isInHomeRoute) {
        Get.offAndToNamed(homeRoute);
      }
      return;
    }
    Log(
      'BusinessAuthCallbacks: authRoutesValidation - Current route: ${Get.currentRoute} ${Get.currentRoute == Routes.verifyPhone}, isInSetupRoute: $isInSetupRoute, user phone verified: ${user?.isPhoneVerified}',
    );

    // Exit early if already on verify phone route to prevent infinite loop
    if (Get.currentRoute != Routes.verifyPhone &&
        user!.isPhoneVerified == false) {
      Get.offAndToNamed(Routes.verifyPhone);
      return;
    } else if (Get.currentRoute == Routes.verifyPhone) {
      if (user!.isPhoneVerified == true) {
        Get.offAndToNamed(Routes.home);
      }
      return;
    }

    if (!isInSetupRoute) {
      // apply redirection logic based on user state
      // If user is not authenticated, redirect to login
      if (user?.isFirstLogin == true) {
        // Redirect to introduction screen for first-time users
        Get.offAndToNamed(Routes.intro);
        return;
      }

      if (authController.pendingInvitation.value != null) {
        Get.offAndToNamed(
          Routes.invitation.replaceFirst(
            ':token',
            authController.pendingInvitation.value!.invitationToken!,
          ),
        );
        return;
      }

      BussinessScope? selectedScope = authController.selectedScope.value;

      Log('Selected scope for redirection: ${selectedScope?.toJson()}');

      if (selectedScope != null) {
        switch (selectedScope) {
          case ProfileScope(:final profile):
            // Redirect to profile home if user has profiles
            if (profile.type == ProfileType.organization) {
              if (profile.locations?.isEmpty == true) {
                // Redirect to setup location if organization profile has no locations
                final targetRoute = Routes.setupProfile.replaceFirst(
                  ':profile_id',
                  profile.id!,
                );
                if (Get.currentRoute != targetRoute) {
                  Get.offAndToNamed(targetRoute);
                }
              } else if (profile.locations?.isNotEmpty == true &&
                  (profile.locations?.first.servicesUp == false ||
                      profile.locations?.first.availabilityUp == false)) {
                // Redirect to profile home if organization profile has locations
                final targetRoute = Routes.setupProfileLocation
                    .replaceFirst(':profile_id', profile.id!)
                    .replaceFirst(':location_id', profile.locations!.first.id!);
                if (Get.currentRoute != targetRoute) {
                  Get.offAndToNamed(targetRoute);
                }
              }
            } else if (profile.type == ProfileType.artist) {
              if (profile.independentArtist == true) {
                if (profile.servicesUp == false ||
                    profile.availabilityUp == false) {
                  // Redirect to profile home if organization profile has locations
                  final targetRoute = Routes.setupProfile.replaceFirst(
                    ':profile_id',
                    profile.id!,
                  );
                  if (Get.currentRoute != targetRoute) {
                    Get.offAndToNamed(targetRoute);
                  }
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
                final targetRoute = Routes.setupProfile.replaceAll(
                  ':profile_id',
                  locationMember.organization!.id!,
                );
                if (Get.currentRoute != targetRoute) {
                  Get.offNamed(targetRoute);
                }
              } else if (locationMember.location != null &&
                  (locationMember.location!.servicesUp == false ||
                      locationMember.location!.availabilityUp == false ||
                      (locationMember.location!.membersUp == false &&
                          locationMember.organization!.type ==
                              ProfileType.organization))) {
                // Redirect to setup location if organization profile has no locations
                final targetRoute = Routes.setupProfileLocation
                    .replaceFirst(
                      ':profile_id',
                      locationMember.organization!.id!,
                    )
                    .replaceFirst(':location_id', locationMember.location!.id!);

                // Prevent infinite loop: only redirect if not already on target route
                if (Get.currentRoute != targetRoute) {
                  Get.offAndToNamed(targetRoute);
                }
              }
            }
            break;
        }
      }
    }
    Log(
      'BusinessAuthCallbacks: authRoutesValidation - Completed route validation, isInAuthTokenRoute: $isInAuthTokenRoute',
    );

    if (isInAuthTokenRoute) {
      Get.offAndToNamed(homeRoute);
      return;
    }
  }

  @override
  Future<void> onLoginRedirection(UserModel? user) async {
    authRoutesValidation(user);
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
    Log(
      'BusinessAuthCallbacks: onAuthValidation - user: ${user?.toJson()}, selectedScope: ${selectedScope?.toJson()}',
    );
    // set user and selected scope in auth controller AFTER redirection
    authController.setUser(user);
    authController.setSelectedScope(selectedScope);

    await onLoginRedirection(user);
  }
}
