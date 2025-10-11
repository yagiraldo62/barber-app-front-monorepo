import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/app_button.dart';

/// A generic step information container
class StepInfo {
  /// The widget to display for this step
  final Widget stepWidget;

  /// Optional condition to determine if this step should be shown
  final bool Function()? condition;

  StepInfo({required this.stepWidget, this.condition});
}

/// Base controller for step-based forms
abstract class StepperFormController<T> {
  /// Get the current step
  T get currentStep;

  /// Get the loading state
  bool get isLoading;

  /// Handle moving to the next step
  void nextStep();
}

/// A generic reusable widget for step-by-step forms
class StepperFormFields<T> extends StatelessWidget {
  /// The controller that handles the form state and navigation logic
  final StepperFormController<T> controller;

  /// List of steps to display in the form
  final List<StepInfo> steps;

  /// Function to determine if a step is the final step
  final bool Function(T step) isFinalStep;

  /// Optional scroll controller to handle scrolling behavior
  final ScrollController? scrollController;

  /// Optional function to customize the button label for each step
  final String Function(T step)? buttonLabelBuilder;

  /// Optional function to customize the button icon for each step
  final IconData Function(T step)? buttonIconBuilder;

  /// Duration for animation effects
  final Duration animationDuration;

  /// Optional condition to determine if the form should be shown
  // final bool Function()? showFormCondition;

  /// Optional condition to determine if the button should be visible
  final bool Function()? showButtonCondition;

  /// Default button label for non-final steps
  final String defaultContinueLabel;

  /// Default button label for the final step
  final String defaultFinalLabel;

  /// Default button icon for non-final steps
  final IconData defaultContinueIcon;

  /// Default button icon for the final step
  final IconData defaultFinalIcon;

  /// Space between steps
  final double stepSpacing;

  /// Button alignment
  final AlignmentGeometry buttonAlignment;
  const StepperFormFields({
    super.key,
    required this.controller,
    required this.steps,
    required this.isFinalStep,
    this.scrollController,
    this.buttonLabelBuilder,
    this.buttonIconBuilder,
    this.animationDuration = const Duration(milliseconds: 200),
    // this.showFormCondition,
    this.showButtonCondition,
    this.defaultContinueLabel = 'Continuar',
    this.defaultFinalLabel = 'Finalizar',
    this.defaultContinueIcon = Icons.arrow_forward,
    this.defaultFinalIcon = Icons.check,
    this.stepSpacing = 32.0,
    this.buttonAlignment = Alignment.centerRight,
  });

  /// Determines the button label based on the current step
  String _getButtonLabel(T step) {
    if (buttonLabelBuilder != null) {
      return buttonLabelBuilder!(step);
    }
    return isFinalStep(step) ? defaultFinalLabel : defaultContinueLabel;
  }

  /// Determines the button icon based on the current step
  IconData _getButtonIcon(T step) {
    if (buttonIconBuilder != null) {
      return buttonIconBuilder!(step);
    }
    return isFinalStep(step) ? defaultFinalIcon : defaultContinueIcon;
  }

  /// Scrolls to the bottom of the form after adding a new step
  void _scrollToBottom() {
    if (scrollController == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController?.hasClients ?? false) {
        scrollController?.animateTo(
          scrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // // Check if the form should be shown
    // if (showFormCondition != null && !showFormCondition!()) {
    //   return const SizedBox.shrink();
    // }

    return Obx(() {
      _scrollToBottom();
      final visibleSteps = <Widget>[];

      // Add visible steps to the list
      for (int i = 0; i < steps.length; i++) {
        final step = steps[i];

        // Check if the step should be shown based on its condition
        if (step.condition != null && !step.condition!()) {
          continue;
        }

        visibleSteps.add(
          Column(
            children: [
              AnimatedOpacity(
                opacity: 1.0,
                duration: animationDuration,
                curve: Curves.easeInOut,
                child: step.stepWidget,
              ),
              SizedBox(height: stepSpacing),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...visibleSteps,
          AnimatedOpacity(
            opacity: 1.0,
            duration: animationDuration,
            curve: Curves.easeInOut,
            child: Align(
              alignment: buttonAlignment,
              child: AppButton(
                onPressed: controller.nextStep,
                label: _getButtonLabel(controller.currentStep),
                icon: Icon(_getButtonIcon(controller.currentStep)),
                isLoading: controller.isLoading,
              ),
            ),
          ),
        ],
      );
    });
  }
}
