import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/members_invite_controller.dart';
import 'member_row.dart';

class MembersList extends StatelessWidget {
  final bool shrinkWrap;
  final MembersInviteController controller;
  const MembersList({
    super.key,
    this.shrinkWrap = false,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.members.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.members.isEmpty) {
        return const Text('No members yet');
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
        itemCount: controller.members.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final m = controller.members[index];
          return MemberRow(
            member: m,
            onRevoke: () => controller.revokeMember(idOf(m)),
          );
        },
      );
    });
  }
}
