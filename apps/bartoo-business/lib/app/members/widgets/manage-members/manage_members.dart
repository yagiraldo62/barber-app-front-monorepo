import 'package:bartoo/app/members/controllers/members_invite_controller.dart';
import 'package:bartoo/app/members/widgets/manage-members/members_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'invitations_list.dart';
import 'members_invite_form.dart';

class ManageMembers extends StatelessWidget {
  final String organizationId;
  final String? locationId;
  final VoidCallback? onContinue;

  const ManageMembers({
    super.key,
    required this.organizationId,
    this.locationId,
    this.onContinue,
  });

  MembersInviteController _getController() {
    final tag = 'members-invite-$organizationId-${locationId ?? 'org'}';
    if (Get.isRegistered<MembersInviteController>(tag: tag)) {
      return Get.find<MembersInviteController>(tag: tag);
    }
    return Get.put(
      MembersInviteController(
        organizationId: organizationId,
        locationId: locationId,
      ),
      tag: tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _getController();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Miembros del equipo',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          if (controller.error.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                controller.error.value,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: 'Invitar',
              icon: const Icon(Icons.person_add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (ctx) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom,
                      ),
                      child: SingleChildScrollView(
                        child: MembersInviteForm(controller: controller),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          if (controller.invitations.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pending Invitations',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Recargar',
                  onPressed: () => controller.loadAll(),
                ),
              ],
            ),
            InvitationsList(shrinkWrap: true, controller: controller),
          ],

          const SizedBox(height: 12),
          if (controller.superAdmins.isNotEmpty) ...[
            Text(
              'Super Administradores',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            MembersList(
              shrinkWrap: true,
              controller: controller,
              members: controller.superAdmins,
            ),
            const SizedBox(height: 16),
          ],
          Text('Miembros', style: Theme.of(context).textTheme.titleMedium),
          MembersList(
            shrinkWrap: true,
            controller: controller,
            members: controller.regularMembers,
          ),
          if (onContinue != null) ...[
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                label: "Continuar",
                onPressed: onContinue,
                icon: const Icon(Icons.check),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
