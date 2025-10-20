import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/typography/typography.dart';

import '../../controllers/location_services_form_controller.dart';
import 'services_templates_selection.dart';
import 'upsert_location_services.dart';

class LocationServicesForm extends StatelessWidget {
  LocationServicesForm({
    super.key,
    required this.profileId,
    required this.locationId,
    required this.servicesUp,
    this.selectedCategoryIds = const [],
    this.onSaved,
  });

  final String profileId;
  final String locationId;
  final bool servicesUp;
  final List<String> selectedCategoryIds;
  final void Function(bool success)? onSaved;

  LocationServicesFormController _getController() {
    final tag = '$profileId-$locationId';

    // Try to find existing controller first
    if (Get.isRegistered<LocationServicesFormController>(tag: tag)) {
      return Get.find<LocationServicesFormController>(tag: tag);
    }

    // If not found, create it (GetX will automatically call onInit)
    return Get.put(
      LocationServicesFormController(
        profileId: profileId,
        locationId: locationId,
        servicesUp: servicesUp,
        selectedCategoryIds: selectedCategoryIds,
      ),
      tag: tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _getController();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.isNotEmpty) {
        return _ErrorState(
          message: controller.error.value,
          onRetry: () => controller.onInit(),
        );
      }

      // Decide which phase to show
      // Show template selection only if explicitly requested (showUpsert is false)
      // and not when there are existing services unless user explicitly goes back
      final bool shouldShowTemplateSelection = !controller.showUpsert.value;

      final bool shouldShowUpsert = !shouldShowTemplateSelection;

      // Capture reactive values
      final hasSelectedTemplate = controller.hasSelectedTemplate.value;
      final hasExistingServices = controller.hasExistingServices;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (shouldShowTemplateSelection) ...[
            ServicesTemplatesSelection(
              locationId: locationId,
              selectedCategoryIds: selectedCategoryIds,
              categories: controller.categories.toList(),
              onConfirmed: (services) {
                controller.applyTemplateServices(services);
                controller.showUpsert.value = true;
              },
            ),
          ] else ...[
            UpsertLocationServices(
              controller: controller,
              // Allow template selection even with existing services
              onSelectTemplate: () {
                // Return to template selection
                controller.showUpsert.value = false;
              },
              onStartFromScratch:
                  !hasExistingServices
                      ? () {
                        // Clear all services to start fresh
                        controller.editableServices.clear();
                      }
                      : null,
              onCancelTemplate:
                  hasSelectedTemplate && hasExistingServices
                      ? () {
                        controller.cancelTemplateSelection();
                      }
                      : null,
            ),
          ],

          const SizedBox(height: 16),
          if (shouldShowUpsert)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (controller.hasExistingServices &&
                    !controller.showUpsert.value) ...[
                  AppButton(
                    label: 'Cancelar',
                    variation: AppButtonVariation.cancel,
                    onPressed: () {
                      onSaved?.call(false);
                    },
                  ),
                  const SizedBox(width: 12),
                ],
                AppButton(
                  label: 'Guardar servicios',
                  isLoading: controller.isSaving.value,
                  onPressed: () async {
                    final updated = await controller.save();
                    onSaved?.call(updated.isNotEmpty);
                  },
                ),
              ],
            ),
        ],
      );
    });
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
