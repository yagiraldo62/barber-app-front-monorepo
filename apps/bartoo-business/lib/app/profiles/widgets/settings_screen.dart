import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/widgets/typography/typography.dart';

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
              _OrganizationCard(scope: scope as LocationMemberScope),
              const SizedBox(height: 16),
            ] else if (scope is ProfileScope) ...[
              _ProfileCard(scope: scope),
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
  final LocationMemberScope scope;

  const _OrganizationCard({required this.scope});

  @override
  Widget build(BuildContext context) {
    final organization = scope.locationMember.organization!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Typography(
                    'Organización',
                    variation: TypographyVariation.titleLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.toNamed('/profiles/${organization.id}/edit');
                  },
                ),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(label: 'Nombre', value: organization.name),
            const SizedBox(height: 12),
            if (organization.title != null && organization.title!.isNotEmpty)
              _InfoRow(label: 'Título', value: organization.title!),
            const SizedBox(height: 12),
            if (organization.description != null &&
                organization.description!.isNotEmpty)
              _InfoRow(label: 'Descripción', value: organization.description!),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Tipo',
              value: organization.type.name.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final ProfileScope scope;

  const _ProfileCard({required this.scope});

  @override
  Widget build(BuildContext context) {
    final profile = scope.profile;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Typography(
                    'Perfil',
                    variation: TypographyVariation.titleLarge,
                    fontWeight: FontWeight.bold,
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
            const Divider(height: 24),
            _InfoRow(label: 'Nombre', value: profile.name),
            const SizedBox(height: 12),
            if (profile.title != null && profile.title!.isNotEmpty)
              _InfoRow(label: 'Título', value: profile.title!),
            const SizedBox(height: 12),
            if (profile.description != null && profile.description!.isNotEmpty)
              _InfoRow(label: 'Descripción', value: profile.description!),
            const SizedBox(height: 12),
            _InfoRow(label: 'Tipo', value: profile.type.name.toUpperCase()),
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
    final organizationId = scope.locationMember.organization?.id;

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
                  child: Typography(
                    'Ubicación',
                    variation: TypographyVariation.titleLarge,
                    fontWeight: FontWeight.bold,
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
            const Divider(height: 24),
            _InfoRow(label: 'Nombre', value: location.name),
            const SizedBox(height: 12),
            if (location.address != null && location.address!.isNotEmpty)
              _InfoRow(label: 'Dirección', value: location.address!),
            const SizedBox(height: 12),
            _InfoRow(label: 'Ciudad', value: location.city),
            const SizedBox(height: 12),
            _InfoRow(label: 'Estado', value: location.state),
            const SizedBox(height: 12),
            _InfoRow(label: 'País', value: location.country),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Typography(
              'Gestión',
              variation: TypographyVariation.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            if (organizationId != null) ...[
              _ManagementButton(
                icon: Icons.design_services,
                label: 'Servicios',
                onPressed: () => Get.toNamed(
                  '/profiles/$organizationId/locations/${location.id}/services/edit',
                ),
              ),
              const SizedBox(height: 8),
              _ManagementButton(
                icon: Icons.schedule,
                label: 'Disponibilidad',
                onPressed: () => Get.toNamed(
                  '/profiles/$organizationId/locations/${location.id}/availability/edit',
                ),
              ),
              const SizedBox(height: 8),
              _ManagementButton(
                icon: Icons.group,
                label: 'Miembros',
                onPressed: () => Get.toNamed(
                  '/profiles/$organizationId/locations/${location.id}/members/edit',
                ),
              ),
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
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        minimumSize: const Size(double.infinity, 48),
      ),
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
