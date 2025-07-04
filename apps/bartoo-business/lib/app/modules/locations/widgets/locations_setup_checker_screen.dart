import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/data/models/artists/artist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/data/models/artists/artist_location_model.dart';

class LocationsSetupCheckerScreen extends StatelessWidget {
  final Widget child;
  LocationsSetupCheckerScreen({super.key, required this.child});

  final authController = Get.find<BusinessAuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final artist = authController.selectedArtist.value;
      if (artist == null ||
          artist.locations == null ||
          artist.locations!.isEmpty) {
        return child; // Si no hay artista o ubicaciones, simplemente muestra el widget hijo
      }

      // Filtrar las ubicaciones que necesitan configuración
      final locationsNeedingSetup =
          artist.locations!
              .where(
                (location) => !location.servicesUp || !location.availabilityUp,
              )
              .toList();

      // Si todas las ubicaciones están configuradas correctamente, muestra el widget hijo
      if (locationsNeedingSetup.isEmpty) {
        return child;
      }

      // Si hay ubicaciones que necesitan configuración, muestra las alertas correspondientes
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Configuración pendiente",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ...locationsNeedingSetup.map(
                (location) => _buildLocationAlert(context, artist, location),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLocationAlert(
    BuildContext context,
    ArtistModel artist,
    ArtistLocationModel location,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ubicación: ${location.name}",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (!location.servicesUp)
              _buildSetupItem(
                context,
                icon: Icons.room_service_outlined,
                title: "Servicios no configurados",
                description:
                    "Configura los servicios que ofreces en esta ubicación",
                buttonText: "Configurar servicios",
                onPressed:
                    () => {
                      if (location.id != null)
                        Get.toNamed(
                          Routes.UPDATE_SERVICES
                              .replaceAll(':artist_id', artist.id)
                              .replaceAll(':artist_location_id', location.id!),
                          parameters: {'isCreation': 'true'},
                        ),
                    },
              ),
            if (!location.servicesUp && !location.availabilityUp)
              const SizedBox(height: 16),
            if (!location.availabilityUp)
              _buildSetupItem(
                context,
                icon: Icons.calendar_month_outlined,
                title: "Disponibilidad no configurada",
                description:
                    "Configura tu horario de atención en esta ubicación",
                buttonText: "Configurar disponibilidad",
                onPressed:
                    () => Get.toNamed(
                      '/artist/availability/setup',
                      arguments: location,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 40, color: Colors.orange),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
            ],
          ),
        ),
      ],
    );
  }
}
