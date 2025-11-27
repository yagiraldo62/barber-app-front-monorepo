import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/members_invite_controller.dart';
import 'member_row.dart';

class InvitationsList extends StatelessWidget {
  final bool shrinkWrap;
  final MembersInviteController controller;
  const InvitationsList({
    super.key,
    this.shrinkWrap = false,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.invitations.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.invitations.isEmpty) {
        return const Text('No invitations');
      }
      String idOf(dynamic m) {
        try {
          return (m as dynamic).id as String? ?? '';
        } catch (_) {
          return '';
        }
      }

      return ListView.separated(
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
        shrinkWrap: shrinkWrap,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.invitations.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final inv = controller.invitations[index];
          return MemberRow(
            member: inv,
            isInvitation: true,
            onCancelInvitation: () => controller.cancelInvitation(idOf(inv)),
            onResendInvitation: () => controller.resendInvitation(inv),
          );
        },
      );
    });
  }
}
