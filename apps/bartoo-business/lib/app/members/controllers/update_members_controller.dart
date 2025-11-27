import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/shared/location_model.dart';
import 'package:get/get.dart';
import 'package:utils/log.dart';

class UpdateMembersController extends GetxController {
  final BusinessAuthController _authController =
      Get.find<BusinessAuthController>();

  final isInitialized = RxBool(false);
  final currentProfile = Rx<ProfileModel?>(null);
  final currentLocation = Rx<LocationModel?>(null);

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
        Log('Loaded location from locationsWorked for members');
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
          Log('Loaded location from owned profile for members');
          return;
        }
      }
    }

    Log('Location with id $locationId under profile $profileId not found');
  }

  /// Callback when members are updated
  void onMembersUpdated() async {
    Log('Members updated');

    // Refresh user data to get updated members
    await _authController.refreshUser();

    // Navigate back
    Get.back();
  }
}
