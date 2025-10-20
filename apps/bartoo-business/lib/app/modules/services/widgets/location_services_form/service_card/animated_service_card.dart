import 'package:bartoo/app/modules/services/controllers/location_services_form_controller.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:core/data/models/location_service_model.dart';
import 'editable_service_card.dart';

/// A service card that highlights itself with an animation when [isHighlighted] is true.
class AnimatedServiceCard extends StatefulWidget {
  const AnimatedServiceCard({
    super.key,
    required this.controller,
    required this.service,
    required this.isHighlighted,
  });

  final LocationServicesFormController controller;
  final LocationServiceModel service;
  final bool isHighlighted;

  @override
  State<AnimatedServiceCard> createState() => AnimatedServiceCardState();
}

class AnimatedServiceCardState extends State<AnimatedServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<Color?>? _colorAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _colorAnimation = ColorTween(
        begin: Colors.transparent,
        end: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

      if (widget.isHighlighted) {
        _animationController.forward();
      }
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(AnimatedServiceCard oldWidget) {
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
    if (_colorAnimation == null) {
      // Fallback while animation is being initialized
      return EditableServiceCard(
        controller: widget.controller,
        service: widget.service,
      );
    }

    return AnimatedBuilder(
      animation: _colorAnimation!,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: _colorAnimation!.value?.withValues(alpha: 0.2),
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
