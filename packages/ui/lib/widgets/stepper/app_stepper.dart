import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppStepperStep {
  final String title;
  final IconData? icon;
  final String? svgAsset;

  const AppStepperStep({required this.title, this.icon, this.svgAsset});
}

const double _defaultIconSize = 25.0;
const double _defaultIconContainerSize = 45.0;

/// Simple horizontal stepper with connectors and labels.
class AppStepper extends StatelessWidget {
  final List<AppStepperStep> steps;
  final int lastStepAvailable;
  final int currentStep;
  final void Function(int index)? onStepTapped;
  final Color? activeColor;
  final Color? completedColor;
  final Color? inactiveColor;
  final double connectorThickness;
  final EdgeInsetsGeometry padding;

  const AppStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.lastStepAvailable,
    this.onStepTapped,
    this.activeColor,
    this.completedColor,
    this.inactiveColor,
    this.connectorThickness = 2.0,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color active = activeColor ?? theme.colorScheme.primary;
    final Color completed =
        completedColor ?? theme.colorScheme.primary.withOpacity(0.80);
    final Color inactive = inactiveColor ?? theme.disabledColor;

    List<Widget> children = [];

    for (int i = 0; i < steps.length; i++) {
      final bool isCompleted = i <= lastStepAvailable;
      final bool isActive = i == currentStep;
      final Color dotColor =
          isActive ? active : (isCompleted ? completed : inactive);

      // Step dot + label
      final step = GestureDetector(
        onTap: onStepTapped != null ? () => onStepTapped!(i) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _defaultIconContainerSize,
              height: _defaultIconContainerSize,
              decoration: BoxDecoration(
                color: isCompleted && !isActive ? Colors.transparent : dotColor,
                border: Border.all(color: dotColor, width: 1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _buildStepIcon(
                  steps[i],
                  isActive,
                  isCompleted,
                  dotColor,
                  theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 80,
              child: Text(
                steps[i].title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color:
                      isActive || isCompleted
                          ? theme.colorScheme.onSurface
                          : theme.hintColor,
                ),
              ),
            ),
          ],
        ),
      );

      children.add(Padding(padding: padding, child: step));

      if (i != steps.length - 1) {
        // Connector line
        children.add(
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              height: connectorThickness,
              color: (i < currentStep) ? completed : inactive.withOpacity(0.6),
            ),
          ),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildStepIcon(
    AppStepperStep step,
    bool isActive,
    bool isCompleted,
    Color dotColor,
    Color onPrimaryColor,
  ) {
    // Priority: svgAsset > icon > default (check/circle)
    if (step.svgAsset != null) {
      return SvgPicture.asset(
        step.svgAsset!,
        width: _defaultIconSize,
        height: _defaultIconSize,
        colorFilter: ColorFilter.mode(
          isCompleted && !isActive ? dotColor : onPrimaryColor,
          BlendMode.srcIn,
        ),
      );
    } else if (step.icon != null) {
      return Icon(
        step.icon,
        size: _defaultIconSize,
        color: isCompleted && !isActive ? dotColor : onPrimaryColor,
      );
    } else {
      return Icon(
        isCompleted && !isActive ? Icons.check : Icons.circle,
        size: _defaultIconSize,
        color: isCompleted ? dotColor : onPrimaryColor,
      );
    }
  }
}
