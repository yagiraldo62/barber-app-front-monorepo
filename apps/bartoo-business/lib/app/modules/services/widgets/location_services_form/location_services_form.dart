import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/app_button.dart';

import 'location_services_form_controller.dart';
import 'services_templates_selection.dart';
import 'upsert_location_services.dart';

class LocationServicesForm extends StatefulWidget {
  const LocationServicesForm({
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

  @override
  State<LocationServicesForm> createState() => _LocationServicesFormState();
}

class _LocationServicesFormState extends State<LocationServicesForm> {
  late final LocationServicesFormController controller;
  final RxBool showUpsert = false.obs;

  @override
  void initState() {
    super.initState();
    controller = LocationServicesFormController(
      profileId: widget.profileId,
      locationId: widget.locationId,
      servicesUp: widget.servicesUp,
    );
    controller.onInit();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      final bool shouldShowUpsert =
          showUpsert.value || controller.hasExistingServices || controller.editableServices.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!shouldShowUpsert) ...[
            ServicesTemplatesSelection(
              locationId: widget.locationId,
              selectedCategoryIds: widget.selectedCategoryIds,
              categories: controller.categories.toList(),
              onConfirmed: (services) {
                controller.editableServices.assignAll(services);
                showUpsert.value = true;
              },
            ),
          ] else ...[
            UpsertLocationServices(controller: controller),
          ],

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              label: 'Guardar servicios',
              isLoading: controller.isSaving.value,
              onPressed: () async {
                final updated = await controller.save();
                widget.onSaved?.call(updated.isNotEmpty);
              },
            ),
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
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
