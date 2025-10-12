import 'package:bartoo/app/modules/locations/controllers/forms/location_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class LocationMapStep extends StatelessWidget {
  final LocationFormController controller;

  const LocationMapStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: '¿Ubicación exacta?',
      descriptionText:
          'Confirma en el mapa el punto exacto donde se encuentra tu negocio',
      onAnimationsComplete: controller.onAnimationsComplete,
      content: Column(
        children: [
          // TODO: Agregar mapa para seleccionar ubicación
          const SizedBox(height: 24),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 40),
    );
  }
}
