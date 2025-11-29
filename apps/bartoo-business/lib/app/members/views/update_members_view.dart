import 'package:bartoo/app/members/controllers/update_members_controller.dart';
import 'package:bartoo/app/members/widgets/manage-members/manage_members.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/layout/app_layout.dart';

class UpdateMembersView extends GetView<UpdateMembersController> {
  const UpdateMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      back: true,
      title: 'Gestionar Miembros',
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.currentProfile.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Perfil no encontrado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'No se pudo cargar la información solicitada',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: ManageMembers(
              organizationId: controller.currentProfile.value!.id!,
              locationId: controller.currentLocation.value?.id,
              onContinue: () => controller.onMembersUpdated(),
            ),
          ),
        );
      }),
    );
  }
}
