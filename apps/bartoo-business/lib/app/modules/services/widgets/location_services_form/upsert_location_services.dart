import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/data/models/location_service_model.dart';

import 'editable_service_card.dart';
import 'location_services_form_controller.dart';

class UpsertLocationServices extends StatelessWidget {
  const UpsertLocationServices({
    super.key,
    required this.controller,
    this.onSelectTemplate,
    this.onStartFromScratch,
  });

  final LocationServicesFormController controller;
  final VoidCallback? onSelectTemplate;
  final VoidCallback? onStartFromScratch;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.editableServices.isEmpty) {
        return _EmptyState(
          onSelectTemplate: onSelectTemplate,
          onStartFromScratch: onStartFromScratch,
        );
      }

      final bySub = controller.servicesBySubcategory;
      final List<Widget> children = [];

      // Show template selection options at the top if available
      if (onSelectTemplate != null || onStartFromScratch != null) {
        children.add(
          _TemplateOptions(
            onSelectTemplate: onSelectTemplate,
            onStartFromScratch: onStartFromScratch,
          ),
        );
        children.add(const SizedBox(height: 16));
        children.add(const Divider());
        children.add(const SizedBox(height: 16));
      }

      bySub.forEach((subId, list) {
        final categoryName = controller.categoryNameForSubcategory(subId);
        final subName = controller.subcategoryName(subId);

        children.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$categoryName · $subName',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                onPressed: () => controller.addService(subcategoryId: subId),
                icon: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  'Añadir servicio',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
        ]);

        for (final s in list) {
          children.add(EditableServiceCard(controller: controller, service: s));
        }

        children.add(const SizedBox(height: 8));
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.onSelectTemplate, this.onStartFromScratch});

  final VoidCallback? onSelectTemplate;
  final VoidCallback? onStartFromScratch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay servicios',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona una plantilla o crea servicios desde cero',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (onSelectTemplate != null || onStartFromScratch != null)
            _TemplateOptions(
              onSelectTemplate: onSelectTemplate,
              onStartFromScratch: onStartFromScratch,
            ),
        ],
      ),
    );
  }
}

class _TemplateOptions extends StatelessWidget {
  const _TemplateOptions({this.onSelectTemplate, this.onStartFromScratch});

  final VoidCallback? onSelectTemplate;
  final VoidCallback? onStartFromScratch;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        if (onSelectTemplate != null)
          OutlinedButton.icon(
            onPressed: onSelectTemplate,
            icon: const Icon(Icons.content_copy),
            label: const Text('Seleccionar plantilla'),
          ),
        if (onStartFromScratch != null)
          OutlinedButton.icon(
            onPressed: onStartFromScratch,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Empezar desde cero'),
          ),
      ],
    );
  }
}
