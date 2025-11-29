import 'package:core/data/models/shared/location_model.dart';
import 'package:get/get.dart';
import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/member_model.dart';
import 'package:core/modules/profile/providers/members_provider.dart';
import 'package:core/modules/profile/providers/member_invitations_provider.dart';
import 'package:utils/log.dart';

class MembersInviteController extends GetxController {
  final String organizationId;
  final String? locationId;
  late final MembersProvider _membersProvider;
  late final MemberInvitationsProvider _invitationsProvider;
  late final BusinessAuthController _authController;
  bool _depsReady = false;

  MembersInviteController({
    required this.organizationId,
    required this.locationId,
  });

  // UI State
  final isLoading = false.obs;
  final error = RxString('');

  // Data
  final members = <MemberModel>[].obs; // accepted members
  final invitations = <MemberModel>[].obs; // pending invitations
  final availableLocationMembers =
      <LocationModel>[].obs; // locations from user (full member objects)

  // Computed lists for separating super admins from regular members
  List<MemberModel> get superAdmins =>
      members.where((m) => m.role == LocationMemberRole.superAdmin).toList();
  List<MemberModel> get regularMembers =>
      members.where((m) => m.role != LocationMemberRole.superAdmin).toList();

  // Form state
  final selectedLocationId = RxString(
    '',
  ); // null = organization, or location id
  final selectedRole = RxString(''); // 'super-admin' | 'manager' | 'member'
  final isArtist = true.obs; // default to true

  // Invite by phone fields
  final phoneNumber = ''.obs;
  final receptorName = ''.obs;
  final sendBy = 'sms'.obs; // 'sms' | 'whatsapp'

  @override
  void onInit() {
    super.onInit();
    _ensureDependencies();
    _loadAvailableLocations();
    _syncDefaultRole();
    loadAll();
  }

  void _ensureDependencies() {
    if (_depsReady) return;
    if (!Get.isRegistered<MembersProvider>()) {
      Get.put(MembersProvider());
    }
    if (!Get.isRegistered<MemberInvitationsProvider>()) {
      Get.put(MemberInvitationsProvider());
    }
    _membersProvider = Get.find<MembersProvider>();
    _invitationsProvider = Get.find<MemberInvitationsProvider>();
    _authController = Get.find<BusinessAuthController>();
    _depsReady = true;
  }

  void _loadAvailableLocations() {
    final user = _authController.user.value;
    if (user?.locationsWorked != null && user!.locationsWorked!.isNotEmpty) {
      // Filter out null locations and remove duplicates based on location ID
      final seenIds = <String>{};
      final uniqueLocations =
          user.locationsWorked!
              .where((e) => e.location != null)
              .map((e) => e.location!)
              .where((location) {
                if (location.id != null && seenIds.contains(location.id)) {
                  return false;
                }
                if (location.id != null) {
                  seenIds.add(location.id!);
                }
                return true;
              })
              .toList();

      availableLocationMembers.assignAll(uniqueLocations);
      // Set location based on props or use first available
      if (locationId != null && locationId!.isNotEmpty) {
        selectedLocationId.value = locationId!;
      } else if (availableLocationMembers.isNotEmpty) {
        // Set first location as default if no locationId provided
        selectedLocationId.value = availableLocationMembers.first.id ?? '';
      }
      // Update role if location is selected
      if (selectedLocationId.value.isNotEmpty) {
        selectedRole.value = 'member';
      }
    }
  }

  void _syncDefaultRole() {
    // Default to organization (null location) if no locations available
    if (availableLocationMembers.isEmpty) {
      selectedLocationId.value = '';
      selectedRole.value = 'member';
    }
  }

  Future<void> loadAll() async {
    isLoading.value = true;
    error.value = '';
    try {
      await _loadMembers();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMembers() async {
    try {
      final list = await _membersProvider.getMembers(
        organizationId: organizationId,
        locationId: locationId,
      );
      final all = list ?? [];
      final accepted = all.where((m) => m.acceptedAt != null).toList();
      final pending = all.where((m) => m.acceptedAt == null).toList();
      members.assignAll(accepted);
      invitations.assignAll(pending);
    } catch (e) {
      // swallow for now, surfaced in error later
    }
  }

  bool get canInviteToOrganization => true;
  bool get canInviteToLocation => locationId != null;

  void changeLocationSelection(String? locationId) {
    selectedLocationId.value = locationId ?? '';
    // Reset role based on selection
    if (locationId == null || locationId.isEmpty || locationId == "org") {
      // Organization selected
      selectedRole.value = 'super-admin';
    } else {
      // Location selected
      selectedRole.value = 'member';
    }
  }

  Future<void> inviteByPhone() async {
    // Validate
    if (receptorName.value.trim().isEmpty) {
      throw Exception('El nombre del receptor es requerido');
    }
    if (phoneNumber.value.trim().isEmpty) {
      throw Exception('El número de teléfono es requerido');
    }

    isLoading.value = true;
    error.value = '';
    try {
      final invitationLocationId =
          selectedLocationId.value.isEmpty ? null : selectedLocationId.value;

      await _invitationsProvider.sendInvitation(
        phoneNumber: phoneNumber.value.trim(),
        receptorName: receptorName.value.trim(),
        organizationId: organizationId,
        locationId: invitationLocationId,
        role: selectedRole.value,
        sendBy: sendBy.value,
      );
      await _loadMembers();
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> revokeMember(String id) async {
    isLoading.value = true;
    error.value = '';
    try {
      if (locationId == null) {
        await _membersProvider.deleteMember(id);
      } else {
        await _membersProvider.revokeMember(
          id,
          organizationId: organizationId,
          locationId: locationId!,
        );
      }
      await _loadMembers();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelInvitation(String id) async {
    isLoading.value = true;
    error.value = '';
    try {
      await _membersProvider.deleteMember(id);
      await _loadMembers();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendInvitation(MemberModel invitation) async {
    isLoading.value = true;
    error.value = '';
    try {
      Log('invitation: ${invitation.toJson()}');
      if (invitation.invitationPhoneNumber == null ||
          invitation.invitationPhoneNumber!.isEmpty) {
        Get.snackbar(
          'Error',
          'Cannot resend invitation: phone number is missing',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final result = await _invitationsProvider.resendInvitation(
        phoneNumber: invitation.invitationPhoneNumber!,
        organizationId: organizationId,
        locationId: invitation.location?.id,
        sendBy: 'sms',
      );

      if (result == null) {
        Get.snackbar(
          'Error',
          'No active invitation found for this phone number',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.snackbar(
        'Success',
        'Invitation resent successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Optionally reload members to refresh the list
      await _loadMembers();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to resend invitation: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
