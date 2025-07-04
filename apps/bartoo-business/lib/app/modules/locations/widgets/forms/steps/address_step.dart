import 'package:bartoo/app/modules/locations/controllers/forms/artist_location_form_controller.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typography/typography.dart';
import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class LocationAddressStep extends StatelessWidget {
  final ArtistLocationFormController controller;

  const LocationAddressStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: '¿Dónde te encuentras?',
      descriptionText:
          'Ingresa la dirección exacta donde atenderás a tus clientes',
      onAnimationsComplete: controller.onAnimationsComplete,
      content: Column(
        children: [
          CommonTextField(
            hintText: 'Ej: Calle 123 # 45-67',
            labelText: 'Dirección principal',
            controller: controller.addressController,
            focusNode: controller.addressFocus,
          ),
          const SizedBox(height: 16),
          CommonTextField(
            hintText: 'Ej: Apto 301, Interior 2',
            labelText: 'Complemento dirección (opcional)',
            controller: controller.address2Controller,
            focusNode: controller.address2Focus,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Typography(
              'Este complemento ayudará a tus clientes a encontrar con mayor precisión tu ubicación.',
              variation: TypographyVariation.labelSmall,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      focusNode: controller.addressFocus,
    );
  }
}
