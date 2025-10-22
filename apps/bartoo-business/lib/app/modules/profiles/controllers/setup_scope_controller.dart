import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/location_service_model.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/shared/location_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:get/get.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:utils/log.dart';

enum CreateProfileStep { profile, location, services, availability }

class SetupScopeController extends GetxController {
  final BusinessAuthController _authController =
      Get.find<BusinessAuthController>();

  final isIndependentArtist = false.obs;

  /// Selected profile type for this creation flow
  final isInitialized = RxBool(false);

  /// Selected profile type for this creation flow
  final profileType = ProfileType.organization.obs;

  /// Current high-level step for the creation flow
  final lastAvailableStep = CreateProfileStep.profile.obs;

  /// Current high-level step for the creation flow
  final currentStep = CreateProfileStep.profile.obs;

  /// Dynamically built list of steps for the flow
  final steps = <CreateProfileStep>[CreateProfileStep.profile].obs;

  /// If navigating with :profile_id, hold the profile to edit
  final currentProfile = Rx<ProfileModel?>(null);

  /// If navigating with :location_id, hold the location to edit
  final currentLocation = Rx<LocationModel?>(null);

  /// True if we are creating a new profile, false if editing existing one9
  final isCreation = false.obs;

  @override
  void onInit() async {
    super.onInit();
    // Read profile type from route args if provided
    final arguments = Get.arguments as Map<String, dynamic>?;
    final userType = arguments?['userType'] as String?;
    if (userType == 'artist') {
      profileType.value = ProfileType.artist;
    } else if (userType == 'organization') {
      profileType.value = ProfileType.organization;
    } else {
      profileType.value = ProfileType.organization;
    }

    // Check for route param :profile_id (SETUP_PROFILE route)
    final profileId = Get.parameters['profile_id'];
    final locationId = Get.parameters['location_id'];
    if ((profileId != null && profileId.isNotEmpty) ||
        (locationId != null && locationId.isNotEmpty)) {
      await _initializeFromSelectedScope(profileId, locationId);
    }

    _buildSteps();

    // delay
    await Future.delayed(const Duration(milliseconds: 300));
    isInitialized.value = true;
  }

  void toggleIsIndependentArtist(bool value) {
    isIndependentArtist.value = value;

    _buildSteps();
  }

  int get currentIndex {
    final index = steps.indexOf(currentStep.value);
    // If current step is not in steps list, default to first step (0)
    if (index < 0) {
      // Reset to first step if current step is invalid
      if (steps.isNotEmpty) {
        currentStep.value = steps.first;
        return 0;
      }
      return 0;
    }
    return index;
  }

  int get lastAvailableIndex {
    final index = steps.indexOf(lastAvailableStep.value);
    // If current step is not in steps list, default to first step (0)
    if (index < 0) {
      // Reset to first step if current step is invalid
      if (steps.isNotEmpty) {
        lastAvailableStep.value = steps.first;
        return 0;
      }
      return 0;
    }
    return index;
  }

  void goTo(int index) {
    if (index < 0 || index >= steps.length) return;
    currentStep.value = steps[index];
  }

  void next() {
    final nextIndex = currentIndex + 1;
    if (nextIndex < steps.length) {
      currentStep.value = steps[nextIndex];
      lastAvailableStep.value = steps[nextIndex];
    }
  }

  void onProfileSaved(ProfileModel profile) async {
    if (_authController.user.value!.isFirstLogin) {
      await _authController.authRepository.updateFirstLogin(false, true);
      _authController.user.value!.isFirstLogin = false;
      _authController.user.value!.isOrganizationMember = true;
    }

    await _authController.refreshUser();

    if (profile.type == ProfileType.artist &&
        profile.independentArtist == false) {
      _authController.setSelectedScope(ProfileScope(profile));
      Get.offAllNamed(Routes.ARTIST_HOME);
      return;
    }

    _authController.selectLocationMemberScope(profile.id!);

    currentProfile.value = profile;
    currentLocation.value = LocationModel(name: profile.name);
    next();
  }

  void onLocationSaved(LocationModel location) async {
    currentLocation.value = location;
    await _authController.refreshUser();

    _authController.selectLocationMemberScope(
      currentProfile.value!.id!,
      location.id!,
    );
    next();
  }

  void onServicesSaved() async {
    await _authController.refreshUser();

    _authController.selectLocationMemberScope(
      currentProfile.value!.id!,
      currentLocation.value!.id!,
    );
    next();
  }

  void onAvailabilitySaved() async {
    await _authController.refreshUser();

    _authController.selectLocationMemberScope(
      currentProfile.value!.id!,
      currentLocation.value!.id!,
    );
    Get.offAllNamed(Routes.ARTIST_HOME);
  }

  /// Initializes the current profile and location based on route parameters and user context.
  ///
  /// This method attempts to populate [currentProfile] and [currentLocation] by matching
  /// the provided route parameters against available data sources in the following priority order:
  /// 1. Currently selected business scope (ProfileScope or LocationMemberScope)
  /// 2. User's owned profiles (if operating under a ProfileScope)
  /// 3. User's worked locations (if operating under a LocationMemberScope)
  ///
  /// **Parameters:**
  /// - [profileId]: Optional profile ID from route parameter `:profile_id`
  /// - [locationId]: Optional location ID from route parameter `:location_id`
  ///
  /// **Side Effects:**
  /// - Sets [currentProfile] if a matching profile is found
  /// - Sets [currentLocation] if a matching location is found
  /// - Updates [profileType] based on the found profile's type
  /// - Sets [isCreation] to false when existing entities are loaded
  ///
  /// **Example Routes:**
  /// - `/setup-profile/:profile_id` - Edit existing profile
  /// - `/setup-profile/:profile_id/:location_id` - Edit specific location within profile
  /// - `/setup-profile` (no params) - Create new profile
  Future<void> _initializeFromSelectedScope(
    String? profileId,
    String? locationId,
  ) async {
    // Retrieve the currently selected business scope from auth controller
    final authState = await _authController.authRepository.getAuthState();

    final user = authState.user;
    final scope = authState.selectedScope;

    // CASE 1: User is operating under a ProfileScope that matches the profileId
    // This occurs when the user owns a profile and is currently working within that context
    if (scope is ProfileScope && scope.profile.id == profileId) {
      // If a specific location ID is also provided in the route,
      // attempt to find that location within the profile's locations
      if (locationId != null &&
          locationId.isNotEmpty &&
          scope.profile.locations != null) {
        var location = scope.profile.locations?.firstWhere(
          (loc) => loc.id == locationId,
        );

        // Set the found location as the current location being edited
        currentLocation.value = location;
      }

      // Set the profile from the current scope as the profile being edited
      currentProfile.value = scope.profile;
      // Inherit the profile type (artist vs organization) from the scope
      profileType.value = scope.profile.type;
      return;
    }
    // CASE 2: User is operating under a LocationMemberScope that matches the locationId
    // This occurs when the user is a member/employee at a location but doesn't own the profile
    else if (scope is LocationMemberScope) {
      // Get the list of all locations where the user works
      final locationsWorked = user?.locationsWorked;

      if (locationsWorked != null) {
        try {
          // Find the specific location member record matching the locationId
          final found = locationsWorked.firstWhere(
            (l) =>
                locationId != null
                    ? l.location?.id == locationId &&
                        l.organization?.id == profileId
                    : l.organization?.id == profileId,
          );

          // If a profileId is also provided and it matches the organization,
          // set the organization/profile as the current profile
          if (profileId != null &&
              profileId.isNotEmpty &&
              found.organization?.id == profileId) {
            currentProfile.value = found.organization;
          }

          if (currentProfile.value != null) {
            currentLocation.value =
                found.location ??
                LocationModel(name: currentProfile.value!.name);
          } else {
            currentLocation.value = found.location;
          }
          // LocationMemberScope always implies an organization context
          profileType.value = currentProfile.value!.type;
          isIndependentArtist.value =
              currentProfile.value!.type == ProfileType.artist
                  ? (currentProfile.value!.independentArtist ?? false)
                  : false;
          return;
        } catch (_) {
          // Location not found in user's worked locations - silently ignore
          // This can happen if the user no longer has access to this location
        }
      }
    }

    // CASE 3: No matching scope found
    // If we reach here, neither case matched. The controller remains in creation mode
    // with no currentProfile or currentLocation set (both remain null)
  }

  void _buildSteps() {
    steps.clear();

    final profileRoutes = [Routes.SETUP_PROFILE, Routes.CREATE_PROFILE];
    final locationRoutes = [Routes.SETUP_LOCATION, Routes.CREATE_LOCATION];

    final creationRoutes = [Routes.CREATE_PROFILE, Routes.CREATE_LOCATION];

    isCreation.value = creationRoutes.contains(Get.currentRoute);

    if (currentProfile.value != null ||
        profileRoutes.contains(Get.currentRoute)) {
      // Editing existing profile - skip profile creation step
      steps.add(CreateProfileStep.profile);
    }

    if (profileType.value == ProfileType.organization ||
        (profileType.value == ProfileType.artist &&
            isIndependentArtist.value == true)) {
      // Add organization-specific steps
      steps.add(CreateProfileStep.location);
      steps.add(CreateProfileStep.services);
      steps.add(CreateProfileStep.availability);

      if (currentProfile.value != null) {
        if (currentLocation.value?.id == null) {
          currentStep.value = CreateProfileStep.location;
        } else if (currentLocation.value?.id != null) {
          if ((currentLocation.value!.servicesUp ?? false) == false) {
            currentStep.value = CreateProfileStep.services;
          } else if (currentLocation.value!.availabilityUp == false) {
            currentStep.value = CreateProfileStep.availability;
          }
        }
      }
    }

    lastAvailableStep.value = currentStep.value;
  }
}
