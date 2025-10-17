import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ui/widgets/form/stepper_form_fields.dart';

import 'availability_form_controller.dart';
import 'package:core/data/models/week_day_availability.dart';
import 'steps/template_selection_step.dart';
import 'steps/customize_step.dart';

class AvailabilityForm extends StatelessWidget {
  const AvailabilityForm({
    super.key,
    required this.profileId,
    required this.locationId,
    this.isCreation = true,
    this.scrollController,
    this.onSaved,
  });

  final String profileId;
  final String locationId;
  final bool isCreation;
  final ScrollController? scrollController;
  final void Function(List<WeekdayAvailabilityModel> updatedAvailability)? onSaved;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AvailabilityFormController>()) {
      Get.put(
        AvailabilityFormController(
          profileId: profileId,
          locationId: locationId,
          isCreation: isCreation,
          scrollController: scrollController,
          onSavedCallback: (updated) {
            onSaved?.call(updated);
          },
        ),
        permanent: false,
      );
    }

    final controller = Get.find<AvailabilityFormController>();

    final steps = [
      StepInfo(
        stepWidget: TemplateSelectionStep(controller: controller),
        condition: () => controller.currentStep.value.index >=
            AvailabilityFormStep.template.index,
      ),
      StepInfo(
        stepWidget: CustomizeAvailabilityStep(controller: controller),
        condition: () => controller.currentStep.value.index >=
            AvailabilityFormStep.customize.index,
      ),
    ];

    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.error.value,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => controller.onInit(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );
      }

      return Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepperFormFields<Rx<AvailabilityFormStep>>(
              controller: controller,
              steps: steps,
              showAllSteps: !isCreation,
              scrollController: scrollController,
              enableAutoScroll: isCreation,
              showButtonCondition: () => controller.animationsComplete.value,
              isFinalStep: (step) => step.value == AvailabilityFormStep.customize,
              buttonLabelBuilder: (step) {
                return step.value == AvailabilityFormStep.customize
                    ? 'Guardar disponibilidad'
                    : 'Continuar';
              },
              buttonIconBuilder: (step) {
                return step.value == AvailabilityFormStep.customize
                    ? Icons.check
                    : Icons.arrow_forward;
              },
            ),
          ],
        ),
      );
    });
  }
}
