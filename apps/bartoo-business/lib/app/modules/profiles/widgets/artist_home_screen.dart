import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bartoo/app/modules/locations/widgets/no_locations_alert.dart';
import 'package:bartoo/app/modules/locations/widgets/locations_setup_checker_screen.dart';

class ArtistHomeScreen extends StatelessWidget {
  ArtistHomeScreen({super.key});

  final authController = Get.find<BusinessAuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final hasLocations = authController.hasSelectedArtistLocations();

          if (!hasLocations) {
            return NoLocationsAlert(
              onCreateLocation: () => Get.toNamed('/artist/locations/create'),
            );
          }

          // Usar el LocationsSetupCheckerScreen como wrapper
          return LocationsSetupCheckerScreen(child: _buildHomeContent(context));
        }),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final artistName =
                authController.selectedArtist.value?.name ?? 'Artista';
            return Text(
              '¡Bienvenido, $artistName!',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            );
          }),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            'Resumen del día',
            Icons.today,
            'Consulta tu agenda y próximos turnos para hoy',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Estadísticas',
            Icons.bar_chart,
            'Revisa tus estadísticas y rendimiento',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Notificaciones',
            Icons.notifications,
            'No tienes notificaciones pendientes',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
