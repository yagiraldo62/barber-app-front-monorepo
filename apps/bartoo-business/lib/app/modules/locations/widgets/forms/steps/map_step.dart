import 'package:bartoo/app/modules/locations/controllers/forms/location_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/form/animated_form_step.dart';
import 'package:ui/widgets/map/location_picker_helper.dart';
import 'package:ui/widgets/map/static_map_view.dart';

class LocationMapStep extends StatelessWidget {
  final LocationFormController controller;
  final currentStep = LocationFormStep.location;

  const LocationMapStep({super.key, required this.controller});

  /// Handle location selection from the map picker
  Future<void> _selectLocation(BuildContext context) async {
    // Get initial location from controller if available
    final initialLocation = controller.location.value;

    // Open location picker
    final selectedLocation = await navigateToLocationPicker(
      context: context,
      initialLocation: initialLocation,
      title: 'Selecciona la ubicación de tu negocio',
      confirmButtonText: 'CONFIRMAR',
    );

    // If location was selected, update the controller
    if (selectedLocation != null) {
      controller.setLocation(selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: '¿Ubicación exacta?',
      descriptionText:
          'Confirma en el mapa el punto exacto donde se encuentra tu negocio',
      scrollToBottom: controller.scrollToBottom,
      noAnimation:
          !controller.isCreation ||
          (controller.lastStepAvailable.value != null &&
              controller.lastStepAvailable.value!.index >= currentStep.index),
      onAnimationsComplete: controller.onAnimationsComplete,
      content: Obx(() {
        final selectedLocation = controller.location.value;

        return Column(
          children: [
            // Button to open location picker
            ElevatedButton.icon(
              onPressed: () => _selectLocation(context),
              icon: const Icon(Icons.map),
              label: Text(
                selectedLocation != null
                    ? 'Cambiar ubicación'
                    : 'Seleccionar ubicación en el mapa',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 16),

            // Display selected location with static map
            if (selectedLocation != null) ...[
              // Static map preview - same zoom as picker for consistency
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: StaticMapView(
                  location: selectedLocation,
                  zoom: 17.0, // Same zoom as picker
                  showMarker: true,
                  markerIcon: Icons.person_pin_circle, // Same icon as picker
                  markerColor: Colors.red, // Same color as picker
                  markerSize: 50, // Same size as picker
                  enableInteractions: false,
                ),
              ),

              const SizedBox(height: 16),

              // Location info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Ubicación seleccionada',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Lat: ${selectedLocation.latitude.toStringAsFixed(6)}, '
                              'Lng: ${selectedLocation.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Info banner when no location selected
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Selecciona la ubicación exacta de tu negocio en el mapa',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        );
      }),
      contentPadding: const EdgeInsets.symmetric(horizontal: 40),
    );
  }
}
