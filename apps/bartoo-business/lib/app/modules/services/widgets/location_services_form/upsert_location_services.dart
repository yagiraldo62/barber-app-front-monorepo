import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:core/data/models/location_service_model.dart';
import 'package:ui/widgets/typography/typography.dart';
import 'package:ui/widgets/button/app_text_button.dart';
import 'package:ui/widgets/button/app_icon_button.dart';
import 'package:ui/widgets/search/search_input.dart';

import 'editable_service_card.dart';
import 'location_services_form_controller.dart';

class UpsertLocationServices extends StatefulWidget {
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
      if (widget.controller.editableServices.isEmpty) {
        return _EmptyState(
          onSelectTemplate: widget.onSelectTemplate,
          onStartFromScratch: widget.onStartFromScratch,
        );
      }

      final bySub = widget.controller.servicesBySubcategory;
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
      children.add(const SizedBox(height: 16));

      bySub.forEach((subId, list) {
        final categoryName = widget.controller.categoryNameForSubcategory(
          subId,
        );
        final subName = widget.controller.subcategoryName(subId);

        children.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Typography(
                  '$subName',
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

        for (final s in list) {
          final isNewlyAdded = widget.controller.newlyAddedService.value == s;
          children.add(
            _AnimatedServiceCard(
              key: _getKeyForService(s),
              controller: widget.controller,
              service: s,
              isHighlighted: isNewlyAdded,
            ),
          );
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
          ElevatedButton.icon(
            onPressed: onSelectTemplate,
            icon: const Icon(Icons.content_copy),
            label: const Text('Seleccionar plantilla'),
          ),
      ],
    );
  }
}

class _AnimatedServiceCard extends StatefulWidget {
  const _AnimatedServiceCard({
    super.key,
    required this.controller,
    required this.service,
    required this.isHighlighted,
  });

  final LocationServicesFormController controller;
  final LocationServiceModel service;
  final bool isHighlighted;

  @override
  State<_AnimatedServiceCard> createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<_AnimatedServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      end: Colors.amber.withOpacity(0.3),
      begin: Colors.transparent,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    if (widget.isHighlighted) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(_AnimatedServiceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted && !oldWidget.isHighlighted) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
      child: EditableServiceCard(
        controller: widget.controller,
        service: widget.service,
      ),
    );
  }
}
