part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const AUTH = _Paths.AUTH;
  static const AUTH_TOKEN = _Paths.AUTH_TOKEN;
  static const INTRO = _Paths.INTRO;
  static const SPLASH = _Paths.SPLASH;
  static const PROFILE = _Paths.PROFILE;
  static const CREATE_PROFILE = _Paths.CREATE_PROFILE;
  static const SETUP_PROFILE = _Paths.SETUP_PROFILE;
  static const SETUP_PROFILE_LOCATION = _Paths.SETUP_PROFILE_LOCATION;
  static const SETUP_LOCATION = _Paths.SETUP_LOCATION;
  static const ARTIST_HOME = _Paths.ARTIST_HOME;
  static const CREATE_LOCATION = _Paths.CREATE_LOCATION;
  static const UPDATE_SERVICES = _Paths.UPDATE_SERVICES;
  static const VERIFY_PHONE = _Paths.VERIFY_PHONE;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const INTRO = '/intro';
  static const AUTH = '/auth';
  static const AUTH_TOKEN = '/auth-t/:token';
  static const SPLASH = '/';
  static const PROFILE = '/profile';
  static const ARTIST_HOME = '/artist-home';

  static const CREATE_PROFILE = '/profiles/new';
  static const SETUP_PROFILE = '/profiles/:profile_id/setup';
  static const SETUP_PROFILE_LOCATION =
      '/profiles/:profile_id/:location_id/setup';

  static const CREATE_LOCATION = '/profiles/:profile_id/locations/new';
  static const SETUP_LOCATION =
      '/profiles/:profile_id/locations/:location_id/setup';

  static const UPDATE_SERVICES =
      '/artist/:artist_id/locations/:artist_location_id/update-services';
  static const VERIFY_PHONE = '/verify-phone';
}
