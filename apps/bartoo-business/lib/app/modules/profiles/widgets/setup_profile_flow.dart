import 'package:bartoo/app/modules/locations/widgets/forms/location_form.dart';
import 'package:bartoo/app/modules/profiles/controllers/setup_scope_controller.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/profile_form.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/stepper/app_stepper.dart';

class FlowStepConfig {
  final CreateProfileStep step;
  final String stepTitle;
  final String title;
  final String? svgAsset;
  final Widget Function() build;

  FlowStepConfig({
    required this.step,
    required this.title,
    required this.stepTitle,
    this.svgAsset,
    required this.build,
  });
}

class SetupScopeFlow extends StatelessWidget {
  final ScrollController? scrollController;
  const SetupScopeFlow({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    Get.put(SetupScopeController());
    final ctrl = Get.find<SetupScopeController>();

    return Obx(() {
      if (!ctrl.isInitialized.value) {
        return const Center(child: CircularProgressIndicator());
      }

      Map<
        CreateProfileStep,
        FlowStepConfig Function(CreateProfileStep, SetupScopeController)
      >
      stepsConfigByType = {
        CreateProfileStep.profile:
            (CreateProfileStep step, SetupScopeController controller) =>
                FlowStepConfig(
                  step: step,
                  title: 'Perfil',
                  stepTitle: 'Crear Organización',
                  svgAsset: "assets/images/svgs/organization.svg",
                  build:
                      () => ProfileForm(
                        currentProfile: controller.currentProfile.value,
                        isCreation: controller.currentProfile.value?.id == null,
                        scrollController: scrollController,
                        onSaved:
                            (profile) => controller.onProfileSaved(profile),
                      ),
                ),
        CreateProfileStep.location:
            (
              CreateProfileStep step,
              SetupScopeController controller,
            ) => FlowStepConfig(
              step: step,
              title: 'Ubicación',
              stepTitle: 'Crear Ubicación',
              svgAsset: "assets/images/svgs/location.svg",
              build:
                  () => LocationForm(
                    currentLocation: controller.currentLocation.value,
                    isCreation: controller.currentLocation.value?.id == null,
                    scrollController: scrollController,
                    onSaved: (location) => controller.onLocationSaved(location),
                  ),
            ),
        CreateProfileStep.services:
            (CreateProfileStep step, SetupScopeController controller) =>
                FlowStepConfig(
                  step: step,
                  title: 'Servicios',
                  stepTitle: 'Configurar Servicios',
                  svgAsset: "assets/images/svgs/services.svg",
                  build: () => const SizedBox(height: 200),
                ),
        CreateProfileStep.availability:
            (CreateProfileStep step, SetupScopeController controller) =>
                FlowStepConfig(
                  step: step,
                  title: 'Disponibilidad',
                  stepTitle: 'Configurar Disponibilidad',
                  svgAsset: "assets/images/svgs/availability.svg",
                  build: () => const SizedBox(height: 200),
                ),
      };

      // Artist: show profile form only (current flow)
      if (ctrl.profileType.value == ProfileType.artist) {
        return ProfileForm(
          currentProfile: ctrl.currentProfile.value,
          isCreation: ctrl.currentProfile.value == null,
          scrollController: scrollController,
        );
      }

      // Organization: build config list then render stepper + body
      final currentIdx = ctrl.currentIndex;
      final lastIdx = ctrl.lastAvailableIndex;
      final configs = ctrl.steps
          .map<FlowStepConfig>((s) => stepsConfigByType[s]!(s, ctrl))
          .toList(growable: false);

      // Safety check: if no configs or invalid index, show empty container
      if (configs.isEmpty || currentIdx < 0 || currentIdx >= configs.length) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppStepper(
            steps: configs
                .map(
                  (c) => AppStepperStep(title: c.title, svgAsset: c.svgAsset),
                )
                .toList(growable: false),
            currentStep: currentIdx,
            lastStepAvailable: lastIdx,
            onStepTapped: (i) {
              // Allow back navigation by tapping previous steps
              if (i <= lastIdx) ctrl.goTo(i);
            },
          ),
          const SizedBox(height: 16),
          Text(
            configs[currentIdx].stepTitle,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          // Center(
          //   child: Text(
          //     configs[currentIdx].stepTitle,
          //     style: Theme.of(context).textTheme.displayMedium,
          //   ),
          // ),
          const SizedBox(height: 16),
          configs[currentIdx].build(),
        ],
      );
    });
  }
}
