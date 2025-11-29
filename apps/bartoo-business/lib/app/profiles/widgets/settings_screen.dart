import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/widgets/typography/typography.dart';
import 'package:ui/widgets/button/app_text_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<BusinessAuthController>();

    return Obx(() {
      final scope = authController.selectedScope.value;

      if (scope == null) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No hay información disponible',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Organization Card
            if (scope is LocationMemberScope &&
                scope.locationMember.organization != null) ...[
              _OrganizationCard(profile: scope.locationMember.organization!),
              const SizedBox(height: 16),
            ] else if (scope is ProfileScope) ...[
              _OrganizationCard(profile: scope.profile),
              const SizedBox(height: 16),
            ],

            // Location Card
            if (scope is LocationMemberScope &&
                scope.locationMember.location != null)
              _LocationCard(scope: scope),
          ],
        ),
      );
    });
  }
}

class _OrganizationCard extends StatelessWidget {
  final ProfileModel profile;

  const _OrganizationCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profile.title != null && profile.title!.isNotEmpty)
                        Row(
                          children: [
                            const SizedBox(width: 44),
                            Typography(
                              profile.title!,
                              variation: TypographyVariation.bodyMedium,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          const Icon(Icons.business, size: 32),
                          const SizedBox(width: 12),
                          Typography(
                            profile.name,
                            variation: TypographyVariation.titleLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.toNamed('/profiles/${profile.id}/edit');
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (profile.type == ProfileType.organization) ...[
              const Divider(),

              const SizedBox(height: 12),
              _ManagementButton(
                icon: Icons.group,
                label: 'Gestionar Miembros',
                onPressed: () {
                  Get.toNamed('/profiles/${profile.id}/members/edit');
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final LocationMemberScope scope;

  const _LocationCard({required this.scope});

  @override
  Widget build(BuildContext context) {
    final location = scope.locationMember.location!;
    final organization = scope.locationMember.organization;
    final organizationId = organization?.id;
    final showManageMembersOption =
        scope.locationMember.organization?.type == ProfileType.organization;
    final showLocationName = location.name != organization?.name;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Typography(
                        location.address != null && location.address!.isNotEmpty
                            ? location.address!
                            : 'Ubicación',
                        variation: TypographyVariation.titleLarge,
                        fontWeight: FontWeight.bold,
                      ),
                      if (showLocationName)
                        Typography(
                          location.name,
                          variation: TypographyVariation.bodyMedium,
                          color: Colors.grey[600],
                        ),
                    ],
                  ),
                ),
                if (organizationId != null)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.toNamed(
                        '/profiles/$organizationId/locations/${location.id}/edit',
                      );
                    },
                  ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 16),

            if (organizationId != null) ...[
              _ManagementButton(
                icon: Icons.design_services,
                label: 'Servicios',
                onPressed:
                    () => Get.toNamed(
                      '/profiles/$organizationId/locations/${location.id}/services/edit',
                    ),
              ),
              const SizedBox(height: 8),
              _ManagementButton(
                icon: Icons.schedule,
                label: 'Disponibilidad',
                onPressed:
                    () => Get.toNamed(
                      '/profiles/$organizationId/locations/${location.id}/availability/edit',
                    ),
              ),
              if (showManageMembersOption) ...[
                const SizedBox(height: 8),
                _ManagementButton(
                  icon: Icons.group,
                  label: 'Miembros',
                  onPressed:
                      () => Get.toNamed(
                        '/profiles/$organizationId/locations/${location.id}/members/edit',
                      ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ManagementButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ManagementButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      label: label,
      onPressed: onPressed,
      icon: Icon(icon),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Typography(
            label,
            variation: TypographyVariation.bodyMedium,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Typography(value, variation: TypographyVariation.bodyMedium),
        ),
      ],
    );
  }
}
