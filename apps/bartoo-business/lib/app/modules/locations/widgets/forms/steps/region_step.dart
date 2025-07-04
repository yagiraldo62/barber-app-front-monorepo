import 'package:bartoo/app/modules/locations/controllers/forms/artist_location_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class LocationRegionStep extends StatelessWidget {
  final ArtistLocationFormController controller;

  const LocationRegionStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: '¿En qué lugar te encuentras?',
      descriptionText: 'Especifica la ciudad, estado y país de tu ubicación',
      onAnimationsComplete: controller.onAnimationsComplete,
      content: Column(
        children: [
          // Campos city y state en una fila
          Row(
            children: [
              Expanded(
                child: CommonTextField(
                  hintText: 'Ej: Medellín',
                  labelText: 'Ciudad',
                  controller: controller.cityController,
                  focusNode: controller.cityFocus,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CommonTextField(
                  hintText: 'Ej: Antioquia',
                  labelText: 'Estado/Provincia',
                  controller: controller.stateController,
                  focusNode: controller.stateFocus,
                ),
              ),
            ],
          ),

          // Campo country
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CommonTextField(
              hintText: 'Ej: Colombia',
              labelText: 'País',
              controller: controller.countryController,
              focusNode: controller.countryFocus,
            ),
          ),
        ],
      ),
      focusNode: controller.cityFocus,
    );
  }
}
