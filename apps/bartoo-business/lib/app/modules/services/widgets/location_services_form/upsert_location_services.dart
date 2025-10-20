import 'package:bartoo/app/modules/services/widgets/location_services_form/service_card/animated_service_card.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:core/data/models/location_service_model.dart';
import 'package:ui/widgets/typography/typography.dart';
import 'package:ui/widgets/button/app_text_button.dart';
import 'package:ui/widgets/button/app_icon_button.dart';
import 'package:ui/widgets/search/search_input.dart';

import '../../controllers/location_services_form_controller.dart';

class UpsertLocationServices extends StatefulWidget {
  const UpsertLocationServices({
    super.key,
    required this.controller,
    this.onSelectTemplate,
    this.onStartFromScratch,
    this.onCancelTemplate,
  });

  final LocationServicesFormController controller;
  final VoidCallback? onSelectTemplate;
  final VoidCallback? onStartFromScratch;
  final VoidCallback? onCancelTemplate;

  @override
  State<UpsertLocationServices> createState() => _UpsertLocationServicesState();
}

class _UpsertLocationServicesState extends State<UpsertLocationServices> {
  final Map<String, GlobalKey> _serviceKeys = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen for newly added services
    widget.controller.newlyAddedService.listen((service) {
      if (service != null) {
        _scrollToService(service);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToService(LocationServiceModel service) {
    final key = _getKeyForService(service);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.2,
        );
      }
    });
  }

  GlobalKey _getKeyForService(LocationServiceModel service) {
    final keyId =
        '${service.subcategoryId}_${service.name}_${service.duration}_${service.price}';
    if (!_serviceKeys.containsKey(keyId)) {
      _serviceKeys[keyId] = GlobalKey();
    }
    return _serviceKeys[keyId]!;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bySub = widget.controller.servicesBySubcategory;
      final visibleSubcategoryIds = widget.controller.visibleSubcategoryIds;
      final hasAnyServices = widget.controller.editableServices.isNotEmpty;

      // If no services and should show empty state
      if (!hasAnyServices && visibleSubcategoryIds.isEmpty) {
        return _EmptyState(
          onSelectTemplate: widget.onSelectTemplate,
          onStartFromScratch: widget.onStartFromScratch,
        );
      }

      final List<Widget> children = [];

      // Search bar and template selection button
      children.add(
        Row(
          children: [
            Expanded(
              child: SearchInput(
                hintText: "Buscar servicios...",
                onChanged: (value) {
                  widget.controller.updateSearchQuery(value);
                },
              ),
            ),
            if (widget.onSelectTemplate != null) ...[
              const SizedBox(width: 8),
              AppIconButton(
                onPressed: widget.onSelectTemplate,
                icon: const Icon(Icons.content_copy),
                tooltip: 'Seleccionar plantilla',
              ),
            ],
          ],
        ),
      );

      if (widget.onCancelTemplate != null) {
        children.addAll([
          const SizedBox(height: 16),
          Typography(
            'Estás editando toda tu base de servicios. ¿Deseas cancelar la selección de la plantilla y restaurar los servicios anteriores?',
            variation: TypographyVariation.bodyMedium,
          ),
          const SizedBox(height: 16),
          AppTextButton(
            onPressed: widget.onCancelTemplate,
            icon: const Icon(Icons.cancel_outlined),
            label: 'Cancelar y restaurar',
          ),
        ]);
      }

      children.add(const SizedBox(height: 16));

      // Show all visible subcategories (even if they don't have services yet)
      for (final subId in visibleSubcategoryIds) {
        final subName = widget.controller.subcategoryName(subId);
        final servicesInSubcategory = bySub[subId] ?? [];

        children.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Typography(
                  subName,
                  variation: TypographyVariation.displayMedium,
                ),
              ),
              AppTextButton(
                label: 'Añadir servicio',
                onPressed:
                    () => widget.controller.addService(subcategoryId: subId),
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ]);

        // Show services if any
        if (servicesInSubcategory.isNotEmpty) {
          for (final s in servicesInSubcategory) {
            final isNewlyAdded = widget.controller.newlyAddedService.value == s;
            children.add(
              AnimatedServiceCard(
                key: _getKeyForService(s),
                controller: widget.controller,
                service: s,
                isHighlighted: isNewlyAdded,
              ),
            );
          }
        } else {
          // Show empty message for subcategory without services
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No hay servicios en esta subcategoría. Presiona "Añadir servicio" para crear uno.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        }

        children.add(const SizedBox(height: 16));
      }

      if (widget.onCancelTemplate != null) {
        children.addAll([
          Align(
            alignment: Alignment.center,
            child: Typography(
              '¡Cuidado!',
              variation: TypographyVariation.displayMedium,
            ),
          ),
          const SizedBox(height: 16),
          Typography(
            'Estás editando toda tu base de servicios. ¿Deseas cancelar la selección de la plantilla y restaurar los servicios anteriores?',
            variation: TypographyVariation.bodyMedium,
          ),
          AppTextButton(
            onPressed: widget.onCancelTemplate,
            icon: const Icon(Icons.cancel_outlined),
            label: 'Cancelar y restaurar',
          ),
        ]);
      }
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
          ElevatedButton.icon(
            onPressed: onSelectTemplate,
            icon: const Icon(Icons.content_copy),
            label: const Text('Seleccionar plantilla'),
          ),
      ],
    );
  }
}
