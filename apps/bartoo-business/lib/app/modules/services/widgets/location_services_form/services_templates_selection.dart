import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/typography/typography.dart';
import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/services_template_item_model.dart';
import 'package:core/data/models/location_service_model.dart';

import '../../controllers/services_templates_selection_controller.dart';
import 'template_selection_buttons.dart';

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
          TemplateSelectionButtons(
            templates: controller.templates,
            selectedTemplateIds: controller.selectedTemplateIds.toList(),
            onTemplateToggle: controller.toggleTemplateSelection,
          ),
          const SizedBox(height: 16),

          // Selected template items summary
          if (controller.selectedTemplateIds.isNotEmpty) ...[
            Typography(
              'Seleccione servicios en las plantillas de tus categorias seleccionadas',
              variation: TypographyVariation.bodyMedium,
            ),
            const SizedBox(height: 16),
            _SelectedItemsList(controller: controller),
            const SizedBox(height: 16),
          ],

          // Confirm button
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              label: 'Personalizar',
              onPressed:
                  controller.selectedTemplateIds.isNotEmpty
                      ? () {
                        final services = controller.buildServicesFromSelected();
                        widget.onConfirmed(services);
                      }
                      : null,
              icon: const Icon(Icons.dashboard_customize),
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
            final subName = controller.subcategoryName(subId);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Typography(
                    subName,
                    variation: TypographyVariation.displayMedium,
                  ),
                  const SizedBox(height: 6),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = (constraints.maxWidth - 6) / 2;
                      final currencyFormat = NumberFormat.currency(
                        locale: 'es_CO',
                        symbol: '',
                        decimalDigits: 0,
                      );
                      return Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                            list
                                .map(
                                  (e) => SizedBox(
                                    width: cardWidth,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Typography(
                                              e.name,
                                              variation:
                                                  TypographyVariation
                                                      .labelMedium,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 4),
                                            Typography(
                                              '${e.duration}min · \$${currencyFormat.format(e.price)}',
                                              variation:
                                                  TypographyVariation
                                                      .labelSmall,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      );
                    },
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
