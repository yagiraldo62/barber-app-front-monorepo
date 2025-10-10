import 'package:core/data/models/artist_location_model.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:bartoo/app/modules/locations/controllers/forms/artist_location_form_controller.dart';
import 'package:bartoo/app/modules/locations/widgets/forms/steps/address_step.dart';
import 'package:bartoo/app/modules/locations/widgets/forms/steps/map_step.dart';
import 'package:bartoo/app/modules/locations/widgets/forms/steps/name_step.dart';
import 'package:bartoo/app/modules/locations/widgets/forms/steps/region_step.dart';
import 'package:ui/widgets/form/stepper_form_fields.dart';

class LocationForm extends StatelessWidget {
  final ArtistLocationModel? currentLocation;
  final bool isCreation;
  final bool showForm;
  final ScrollController? scrollController;

  const LocationForm({
    super.key,
    this.currentLocation,
    this.isCreation = true,
    this.showForm = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize or find the controller
    if (!Get.isRegistered<ArtistLocationFormController>()) {
      Get.put(
        ArtistLocationFormController(
          currentLocation: currentLocation,
          isCreation: isCreation,
        ),
      );
    }

    final controller = Get.find<ArtistLocationFormController>();

    // Define steps for the form
    final steps = [
      StepInfo(
        stepWidget: LocationNameStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                LocationFormStep.name.index,
      ),
      StepInfo(
        stepWidget: LocationAddressStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                LocationFormStep.address.index,
      ),
      StepInfo(
        stepWidget: LocationRegionStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                LocationFormStep.region.index,
      ),
      StepInfo(
        stepWidget: LocationMapStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                LocationFormStep.location.index,
      ),
    ];

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepperFormFields<Rx<LocationFormStep>>(
            controller: controller,
            steps: steps,
            isFinalStep: (step) => step.value == LocationFormStep.location,
            scrollController: scrollController,
            showFormCondition: () => showForm,
            showButtonCondition: () => controller.animationsComplete.value,
            buttonLabelBuilder: (step) {
              return step.value == LocationFormStep.location
                  ? 'Finalizar'
                  : 'Continuar';
            },
            buttonIconBuilder: (step) {
              return step.value == LocationFormStep.location
                  ? Icons.check
                  : Icons.arrow_forward;
            },
          ),
        ],
      ),
    );
  }
}
