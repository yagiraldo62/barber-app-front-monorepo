import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/members_invite_controller.dart';
import 'member_row.dart';

class MembersList extends StatelessWidget {
  final bool shrinkWrap;
  final MembersInviteController controller;
  final List<dynamic>? members;
  const MembersList({
    super.key,
    this.shrinkWrap = false,
    required this.controller,
    this.members,
  });
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final membersList = members ?? controller.members;
      if (controller.isLoading.value && membersList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (membersList.isEmpty) {
        return const Text('No hay miembros');
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
        itemCount: membersList.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final m = membersList[index];
          return MemberRow(
            member: m,
            onRevoke: () => controller.revokeMember(idOf(m)),
          );
        },
      );
    });
  }
}
