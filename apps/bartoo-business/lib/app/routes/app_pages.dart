import 'package:get/get.dart';

import '../modules/appointments/bindings/artist_appointments_binding.dart';
import '../modules/appointments/bindings/schedule_appointment_binding.dart';
import '../modules/profiles/bindings/artist_home_binding.dart';
import '../modules/profiles/bindings/artist_profile_binding.dart';
import '../modules/profiles/bindings/create_artist_binding.dart';
import '../modules/profiles/views/artist_home_view.dart';
import '../modules/profiles/views/artist_profile_view.dart';
import '../modules/profiles/views/create_artist_view.dart';
import '../modules/auth/views/first_login_intro/first_login_intro_view.dart';
import '../modules/auth/views/auth_token_view.dart';
import '../modules/auth/views/splash_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/locations/bindings/create_location_binding.dart';
import '../modules/locations/views/create_location_view.dart';
import '../modules/services/bindings/update_services_binding.dart';
import '../modules/services/views/update_services_view.dart';

part 'app_routes.dart';

class AppPages {
  // Private constructor to prevent instantiation of AppPages.
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // AUTH PAGES
    GetPage(name: _Paths.SPLASH, page: () => SplashView()),
    GetPage(name: _Paths.AUTH_TOKEN, page: () => const AuthTokenView()),
    // GetPage(name: _Paths.AUTH, page: () => const AuthView()),
    GetPage(name: _Paths.INTRO, page: () => FirstLoginIntroView()),
    // APP PAGES
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      bindings: [HomeBinding()],
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ArtistProfileView(),
      binding: ArtistProfileBinding(),
    ),
    GetPage(
      name: _Paths.ARTIST_HOME,
      page: () => ArtistHomeView(),
      bindings: [
        ArtistHomeBinding(),
        CreateArtistBinding(),
        ArtistAppointmentsBinding(),
        ScheduleAppointmentBinding(),
      ],
    ),
    GetPage(
      name: _Paths.CREATE_PROFILE,
      page: () => CreateArtistView(),
      bindings: [CreateArtistBinding()],
    ),
    GetPage(
      name: _Paths.CREATE_LOCATION,
      page: () => CreateLocationView(),
      binding: CreateLocationBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_SERVICES,
      page: () => UpdateServicesView(),
      binding: UpdateServicesBinding(),
    ),
  ];
}
