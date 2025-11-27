import 'package:bartoo/app/members/views/invitation_view.dart';
import 'package:get/get.dart';

import '../auth/middlewares/auth_guard_middleware.dart';
import '../appointments/bindings/artist_appointments_binding.dart';
import '../appointments/bindings/schedule_appointment_binding.dart';
import '../profiles/bindings/artist_home_binding.dart';
import '../profiles/bindings/artist_profile_binding.dart';
import '../profiles/bindings/setup_profile_binding.dart';
import '../profiles/bindings/update_profile_binding.dart';
import '../profiles/views/artist_home_view.dart';
import '../profiles/views/artist_profile_view.dart';
import '../profiles/views/setup_scope_view.dart';
import '../profiles/views/update_profile_view.dart';
import '../auth/views/first_login_intro/first_login_intro_view.dart';
import '../auth/views/auth_token_view.dart';
import '../locations/bindings/location_form_binding.dart';
import '../locations/bindings/update_location_binding.dart';
import '../locations/views/create_location_view.dart';
import '../locations/views/update_location_view.dart';
import '../services/bindings/update_services_binding.dart';
import '../services/views/update_services_view.dart';
import '../availability/bindings/update_availability_binding.dart';
import '../availability/views/update_availability_view.dart';
import '../members/bindings/update_members_binding.dart';
import '../members/views/update_members_view.dart';
import '../auth/bindings/phone_verification_binding.dart';
import 'package:ui/widgets/auth/phone_verification_view.dart';

part 'app_routes.dart';

List<Bindings> homeBindings = [
  ArtistHomeBinding(),
  ArtistAppointmentsBinding(),
  ScheduleAppointmentBinding(),
];

GetPage getHomePage(String routeName) {
  return GetPage(
    name: routeName,
    page: () => ArtistHomeView(),
    bindings: homeBindings,
    middlewares: [AuthGuardMiddleware()],
  );
}

class AppPages {
  // Private constructor to prevent instantiation of AppPages.
  AppPages._();

  static const initialRoute = Routes.home;

  static final routes = [
    // AUTH PAGES
    // GetPage(name: Routes.splash, page: () => SplashView()),
    getHomePage(Routes.home),
    GetPage(
      name: Routes.home,
      page: () => ArtistHomeView(),
      bindings: [
        ArtistHomeBinding(),
        SetupScopeBinding(),
        ArtistAppointmentsBinding(),
        ScheduleAppointmentBinding(),
      ],
      middlewares: [AuthGuardMiddleware()],
    ),

    // Client Home Page
    // GetPage(
    //   name: Routes.home,
    //   page: () => const HomeView(),
    //   bindings: [HomeBinding()],
    // ),

    // AUTH VALIDATION WITH TOKEN PAGE
    GetPage(name: Routes.authToken, page: () => const AuthTokenView()),

    // GetPage(name: Routes.auth, page: () => const AuthView()),

    // INTRO PAGE
    GetPage(name: Routes.intro, page: () => FirstLoginIntroView()),

    // PHONE VERIFICATION PAGE
    GetPage(
      name: Routes.verifyPhone,
      page: () => PhoneVerificationView(),
      binding: PhoneVerificationBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),

    // INVITATION PAGE
    GetPage(
      name: Routes.invitation,
      page: () => InvitationView(),
      middlewares: [], // Sin middlewares para permitir acceso público
    ),

    // APP PAGES
    GetPage(
      name: Routes.profile,
      page: () => const ArtistProfileView(),
      binding: ArtistProfileBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.artistHome,
      page: () => ArtistHomeView(),
      bindings: [
        ArtistHomeBinding(),
        SetupScopeBinding(),
        ArtistAppointmentsBinding(),
        ScheduleAppointmentBinding(),
      ],
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.createProfile,
      page: () => SetupScopeView(),
      bindings: [SetupScopeBinding()],
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.setupProfile,
      page: () => SetupScopeView(),
      bindings: [SetupScopeBinding()],
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.setupProfileLocation,
      page: () => SetupScopeView(),
      bindings: [SetupScopeBinding()],
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.createLocation,
      page: () => CreateLocationView(),
      binding: LocationFormBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.updateServicesOld,
      page: () => UpdateServicesView(),
      binding: UpdateServicesBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.updateProfile,
      page: () => const UpdateProfileView(),
      binding: UpdateProfileBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.updateLocation,
      page: () => const UpdateLocationView(),
      binding: UpdateLocationBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.updateServices,
      page: () => const UpdateServicesView(),
      binding: UpdateServicesBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.updateAvailability,
      page: () => const UpdateAvailabilityView(),
      binding: UpdateAvailabilityBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.updateMembers,
      page: () => const UpdateMembersView(),
      binding: UpdateMembersBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    getHomePage(Routes.homeNavigation),
  ];
}
