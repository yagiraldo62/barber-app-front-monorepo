import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/member_model.dart';
import 'package:get/get.dart';
import 'package:core/modules/profile/providers/member_invitations_provider.dart';

class InvitationDetailsController extends GetxController {
  final String token;
  final void Function(bool accepted)? onResponded;

  final BusinessAuthController _authController =
      Get.find<BusinessAuthController>();

  InvitationDetailsController({required this.token, this.onResponded});

  late final MemberInvitationsProvider _provider;

  final isLoading = true.obs;
  final isResponding = false.obs;
  final error = RxnString();
  final invitation = Rxn<MemberModel>();

  bool get isAuthenticated => _authController.user.value != null;

  bool get isValidUser =>
      isAuthenticated &&
      _authController.user.value!.isPhoneVerified == true &&
      _authController.user.value!.phoneNumber ==
          invitation.value?.invitationPhoneNumber;

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<MemberInvitationsProvider>()) {
      Get.put(MemberInvitationsProvider());
    }
    _provider = Get.find<MemberInvitationsProvider>();
    load();
  }

  beforeLogin() {
    if (invitation.value != null) invitation.value!.invitationToken = token;

    _authController.setPendingInvitation(invitation.value);
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      final data = await _provider.getInvitationByToken(token);
      if (data == null) {
        error.value = 'Invitation not found';
      } else {
        invitation.value = data;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> respond(bool accept) async {
    isResponding.value = true;
    error.value = null;
    try {
      if (accept) {
        await _provider.acceptInvitation(token);
      } else {
        await _provider.declineInvitation(token);
      }
      onResponded?.call(accept);
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isResponding.value = false;
    }
  }
}
