import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/shared/location_model.dart';
import 'package:get/get.dart';
import 'package:utils/log.dart';

class UpdateAvailabilityController extends GetxController {
  final BusinessAuthController _authController =
      Get.find<BusinessAuthController>();

  final isInitialized = RxBool(false);
  final currentProfile = Rx<ProfileModel?>(null);
  final currentLocation = Rx<LocationModel?>(null);
  final isCreation = RxBool(false);

  @override
  void onInit() async {
    super.onInit();
    await _loadFromRoute();
    isInitialized.value = true;
  }

  /// Loads the profile and location from route parameters.
  Future<void> _loadFromRoute() async {
    final profileId = Get.parameters['profile_id'];
    final locationId = Get.parameters['location_id'];

    if (profileId == null || profileId.isEmpty) {
      Log('No profile_id provided in route');
      return;
    }

    if (locationId == null || locationId.isEmpty) {
      Log('No location_id provided in route');
      return;
    }

    final user = _authController.user.value;
    if (user == null) {
      Log('No authenticated user found');
      return;
    }

    // First, search in locations where user works
    if (user.locationsWorked != null && user.locationsWorked!.isNotEmpty) {
      final locationMember = user.locationsWorked!.firstWhereOrNull(
        (lm) =>
            lm.location?.id == locationId && lm.organization?.id == profileId,
      );

      if (locationMember != null) {
        currentProfile.value = locationMember.organization;
        currentLocation.value = locationMember.location;
        _determineCreationMode();
        Log('Loaded location from locationsWorked for availability');
        return;
      }
    }

    // Fallback: search in owned profiles
    if (user.profiles != null && user.profiles!.isNotEmpty) {
      final profile = user.profiles!.firstWhereOrNull((p) => p.id == profileId);

      if (profile != null && profile.locations != null) {
        final location = profile.locations!.firstWhereOrNull(
          (l) => l.id == locationId,
        );

        if (location != null) {
          currentProfile.value = profile;
          currentLocation.value = location;
          _determineCreationMode();
          Log('Loaded location from owned profile for availability');
          return;
        }
      }
    }

    Log('Location with id $locationId under profile $profileId not found');
  }

  /// Determine if it's creation or update mode based on availabilityUp flag
  void _determineCreationMode() {
    isCreation.value =
        currentLocation.value?.availabilityUp == false ||
        currentLocation.value?.availabilityUp == null;
  }

  /// Callback when availability is saved
  void onAvailabilitySaved() async {
    Log('Availability updated');

    // Refresh user data to get updated availability
    await _authController.refreshUser();

    // Navigate back
    Get.back();
  }
}
