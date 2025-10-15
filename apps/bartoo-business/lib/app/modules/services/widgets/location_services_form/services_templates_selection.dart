import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/selectable_button.dart';
import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/services_template_item_model.dart';
import 'package:core/data/models/location_service_model.dart';

import 'services_templates_selection_controller.dart';

class ServicesTemplatesSelection extends StatefulWidget {
  const ServicesTemplatesSelection({
    super.key,
    required this.locationId,
    required this.selectedCategoryIds,
    this.categories = const <CategoryModel>[],
    required this.onConfirmed,
  });

  final String locationId;
  final List<String> selectedCategoryIds;
  final List<CategoryModel> categories;
  final void Function(List<LocationServiceModel> services) onConfirmed;

  @override
  State<ServicesTemplatesSelection> createState() =>
      _ServicesTemplatesSelectionState();
}

class _ServicesTemplatesSelectionState
    extends State<ServicesTemplatesSelection> {
  late final ServicesTemplatesSelectionController controller;

  @override
  void initState() {
    super.initState();
    controller = ServicesTemplatesSelectionController(
      categoryIds: widget.selectedCategoryIds,
      locationId: widget.locationId,
      categories: widget.categories,
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
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.error.value,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: controller.loadTemplates,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected categories summary
          Text(
            'Categorías seleccionadas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (widget.categories.isEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  widget.selectedCategoryIds
                      .map((id) => Chip(label: Text(id)))
                      .toList(),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  widget.categories
                      .where((c) => widget.selectedCategoryIds.contains(c.id))
                      .map((c) => Chip(label: Text(c.name ?? '')))
                      .toList(),
            ),

          const SizedBox(height: 12),

          // Selected template items summary
          if (controller.selectedTemplateIds.isNotEmpty) ...[
            Text(
              'Servicios en plantillas seleccionadas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _SelectedItemsList(controller: controller),
            const SizedBox(height: 16),
          ],

          // Templates list
          Text(
            'Plantillas disponibles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (controller.templates.isEmpty)
            const Text('No hay plantillas para las categorías seleccionadas')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  controller.templates
                      .map(
                        (t) => SelectableButton(
                          selected: controller.selectedTemplateIds.contains(
                            t.id,
                          ),
                          onSelectionChange:
                              () => controller.toggleTemplateSelection(t.id),
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
                                if (t.category != null)
                                  Text(
                                    t.category!.name ?? '',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          const SizedBox(height: 16),

          // Confirm button
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed:
                  controller.selectedTemplateIds.isNotEmpty
                      ? () {
                        final services = controller.buildServicesFromSelected();
                        widget.onConfirmed(services);
                      }
                      : null,
              icon: const Icon(Icons.check_circle),
              label: const Text('Confirmar selección y personalizar'),
            ),
          ),
        ],
      );
    });
  }
}

class _SelectedItemsList extends StatelessWidget {
  const _SelectedItemsList({required this.controller});
  final ServicesTemplatesSelectionController controller;

  @override
  Widget build(BuildContext context) {
    final items = controller.selectedTemplateItems;
    if (items.isEmpty) return const SizedBox.shrink();

    final bySub = <String, List<ServicesTemplateItemModel>>{};
    for (final i in items) {
      bySub.putIfAbsent(i.subcategoryId, () => []).add(i);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          bySub.entries.map((entry) {
            final subId = entry.key;
            final list = entry.value;
            final categoryName = controller.categoryNameForSubcategory(subId);
            final subName = controller.subcategoryName(subId);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$categoryName · $subName',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children:
                        list
                            .map(
                              (e) => Chip(
                                label: Text(
                                  '${e.name} · ${e.duration}min · ${e.price}',
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
