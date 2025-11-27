import 'package:bartoo/app/locations/controllers/forms/location_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class LocationNameStep extends StatelessWidget {
  final LocationFormController controller;
  final currentStep = LocationFormStep.name;

  const LocationNameStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      introText:
          'Puedes crear una o varias sedes para tu negocio, cada una con su equipo, horarios y servicios.',
      title: '¿Cómo identificarás esta ubicación?',
      descriptionText:
          'El nombre ayudará a tus clientes a diferenciar entre tus distintas ubicaciones',
      noAnimation:
          !controller.isCreation ||
          (controller.lastStepAvailable.value != null &&
              controller.lastStepAvailable.value!.index >= currentStep.index),
      scrollToBottom: controller.scrollToBottom,
      onAnimationsComplete: controller.onAnimationsComplete,
      content: CommonTextField(
        hintText: 'Ej: Sede Principal, Local Centro',
        labelText: 'Nombre',
        controller: controller.nameController,
        focusNode: controller.nameFocus,
      ),
      focusNode: controller.nameFocus,
    );
  }
}
