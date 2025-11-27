import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/input/dropdown_field.dart';
import '../../../../members/controllers/members_invite_controller.dart';

class RoleSelector extends StatelessWidget {
  final MembersInviteController controller;
  const RoleSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOrganization = controller.selectedLocationId.value == "org";
      final roles =
          isOrganization ? const ['super-admin'] : const ['member', 'manager'];

      return CommonDropdownField<String>(
        labelText: 'Rol',
        value:
            controller.selectedRole.value.isEmpty
                ? roles.first
                : controller.selectedRole.value,
        items:
            roles
                .map(
                  (r) => DropdownMenuItem(
                    value: r,
                    child: Text(r.replaceAll('_', ' ').toUpperCase()),
                  ),
                )
                .toList(),
        onChanged:
            isOrganization
                ? null // Disable dropdown for organization
                : (v) {
                  if (v != null) controller.selectedRole.value = v;
                },
        enabled: !isOrganization,
      );
    });
  }
}
