import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/user/user_model.dart';
import 'package:core/data/models/artists/artist_model.dart';
import 'package:core/modules/auth/interfaces/auth_callbacks.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:utils/geolocation/map_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Business app specific implementation of auth callbacks
class BusinessAuthCallbacks implements AuthCallbacks {
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();

  @override
  Future<void> onLogin(UserModel user) async {
    print('Business app: onLogin - ${user.toJson()}');
    List<ArtistModel> artists = user.artists ?? [];

    // Set user location
    user = await onSetUserLocation(user);

    // Set selected artist if user has artists and none is selected
    if (artists.isNotEmpty) {
      await authRepository.setSelectedArtist(artists.first);
    }

    // Save authenticated user
    await authRepository.setAuthUser(user);

    // Redirect user after login
    onLoginRedirection(user);
  }

  @override
  void onLoginRedirection(UserModel? user) {
    print('Business app: onLoginRedirection - ${user?.toJson()}');

    // apply redirection logic based on user state
    // If user is not authenticated, redirect to login
    if (authController.user.value == null) {
      if (user?.isFirstLogin == true) {
        // Redirect to introduction screen for first-time users
        Get.offAndToNamed(dotenv.env['INTRODUCTION_ROUTE'] ?? '/intro');
      } else if (user?.artists?.isNotEmpty ?? false) {
        // Redirect to artist home if user has artists
        Get.offAndToNamed(dotenv.env['ARTIST_HOME_ROUTE'] ?? '/artist-home');
      } else {
        // Redirect to regular home screen
        Get.offAndToNamed(dotenv.env['HOME_ROUTE'] ?? '/');
      }
    }
  }

  @override
  Future<void> onLogout() async {
    print('Business app: onLogout - Cleaning up business-specific data');
    // Add any business-specific cleanup logic here
    // For example: clear cached data, reset app state, etc.
  }

  @override
  Future<UserModel> onSetUserLocation(UserModel user) async {
    print('Business app: onSetUserLocation');
    Position? position = await getUserCurrentLocation();
    if (position != null) {
      user.location = position.toJson();
    }
    return user;
  }

  @override
  Future<void> onAuthValidation(
    UserModel? user,
    ArtistModel? selectedArtist,
  ) async {
    onLoginRedirection(user);

    // set user and selected artist in auth controller AFTER redirection
    authController.setUser(user);
    authController.setSelectedArtist(selectedArtist);
  }
}
