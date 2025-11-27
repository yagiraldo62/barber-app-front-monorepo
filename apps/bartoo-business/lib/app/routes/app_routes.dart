part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const home = '/';
  static const auth = '/auth';
  static const authTokenRouteSegment = 'auth-t';
  static const authToken = '/$authTokenRouteSegment/:token';
  static const intro = '/intro';
  static const splash = '/';
  static const profile = '/profile';
  static const createProfile = '/profiles/new';
  static const setupProfile = '/profiles/:profile_id/setup';
  static const setupProfileLocation =
      '/profiles/:profile_id/:location_id/setup';
  static const setupLocation =
      '/profiles/:profile_id/locations/:location_id/setup';
  static const artistHome = '/artist-home';
  static const createLocation = '/profiles/:profile_id/locations/new';
  static const updateServicesOld =
      '/artist/:artist_id/locations/:artist_location_id/update-services';
  static const verifyPhone = '/verify-phone';
  static const invitation = '/invitation/:token';
  static const homeNavigation = '/:nav_index';
  static const updateProfile = '/profiles/:profile_id/edit';
  static const updateLocation =
      '/profiles/:profile_id/locations/:location_id/edit';
  static const updateServices =
      '/profiles/:profile_id/locations/:location_id/services/edit';
  static const updateAvailability =
      '/profiles/:profile_id/locations/:location_id/availability/edit';
  static const updateMembers =
      '/profiles/:profile_id/locations/:location_id/members/edit';
}
