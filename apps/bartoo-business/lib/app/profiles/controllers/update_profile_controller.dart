import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:get/get.dart';
import 'package:utils/log.dart';

class UpdateProfileController extends GetxController {
  final BusinessAuthController _authController =
      Get.find<BusinessAuthController>();

  final isInitialized = RxBool(false);
  final currentProfile = Rx<ProfileModel?>(null);

  @override
  void onInit() async {
    super.onInit();
    await _loadProfileFromRoute();
    isInitialized.value = true;
  }

  /// Loads the profile to edit based on the :profile_id route parameter.
  /// Searches in user.profiles (owned) and user.locationsWorked (member of).
  Future<void> _loadProfileFromRoute() async {
    final profileId = Get.parameters['profile_id'];

    if (profileId == null || profileId.isEmpty) {
      Log('No profile_id provided in route');
      return;
    }

    final user = _authController.user.value;
    if (user == null) {
      Log('No authenticated user found');
      return;
    }

    // First, search in user's owned profiles
    if (user.profiles != null && user.profiles!.isNotEmpty) {
      final ownedProfile = user.profiles!.firstWhereOrNull(
        (p) => p.id == profileId,
      );
      if (ownedProfile != null) {
        currentProfile.value = ownedProfile;
        Log('Loaded owned profile: ${ownedProfile.name}');
        return;
      }
    }

    // Second, search in locations where user works (organization profiles)
    if (user.locationsWorked != null && user.locationsWorked!.isNotEmpty) {
      final locationMember = user.locationsWorked!.firstWhereOrNull(
        (lm) => lm.organization?.id == profileId,
      );
      if (locationMember?.organization != null) {
        currentProfile.value = locationMember!.organization;
        Log(
          'Loaded organization profile from locationsWorked: ${locationMember.organization!.name}',
        );
        return;
      }
    }

    Log('Profile with id $profileId not found');
  }

  /// Callback when profile is saved
  void onProfileSaved(ProfileModel updatedProfile) async {
    Log('Profile updated: ${updatedProfile.name}');

    // Refresh user data to get updated profile
    await _authController.refreshUser();

    // Navigate back or to a specific location
    Get.back();
  }
}
