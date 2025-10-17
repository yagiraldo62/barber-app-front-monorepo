import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/selectable_button.dart';

import 'package:core/data/models/availability_template_model.dart';
import '../availability_form_controller.dart';

class TemplateSelectionStep extends StatelessWidget {
  const TemplateSelectionStep({super.key, required this.controller});

  final AvailabilityFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // If existing availability, allow switching templates but show hint
      final hasExisting = controller.hasExistingAvailability;
      final templates = controller.templates;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasExisting)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Ya tienes una disponibilidad configurada. Puedes conservarla o seleccionar una plantilla nueva.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
          Text(
            'Plantillas disponibles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (templates.isEmpty)
            const Text('No hay plantillas de disponibilidad disponibles')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: templates
                  .map(
                    (AvailabilityTemplateModel t) => SelectableButton(
                      selected: controller.selectedTemplateId.value == t.id,
                      onSelectionChange: () {
                        controller.selectedTemplateId.value = t.id;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.name),
                            if ((t.description).isNotEmpty)
                              Text(
                                t.description,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () {
                if (controller.selectedTemplateId.value.isEmpty && !hasExisting) {
                  return;
                }
                if (controller.selectedTemplateId.value.isNotEmpty) {
                  final template = controller.templates.firstWhere(
                    (e) => e.id == controller.selectedTemplateId.value,
                  );
                  controller.setEditableFromTemplate(template);
                }
                controller.nextStep();
              },
              icon: const Icon(Icons.check_circle),
              label: Text(
                hasExisting
                    ? 'Conservar/usar plantilla y continuar'
                    : 'Confirmar selección y personalizar',
              ),
            ),
          ),
        ],
      );
    });
  }
}

