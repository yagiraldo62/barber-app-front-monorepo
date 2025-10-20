import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typography/typography.dart';

enum AppButtonVariation { primary, secondary, cancel }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? elevation;
  final AppButtonVariation variation;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.elevation,
    this.variation = AppButtonVariation.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on variation
    final Color defaultBackgroundColor;
    final Color defaultTextColor;

    switch (variation) {
      case AppButtonVariation.primary:
        defaultBackgroundColor = colorScheme.primary;
        defaultTextColor = colorScheme.onPrimary;
        break;
      case AppButtonVariation.secondary:
        defaultBackgroundColor = colorScheme.secondary;
        defaultTextColor = colorScheme.onSecondary;
        break;
      case AppButtonVariation.cancel:
        defaultBackgroundColor = colorScheme.errorContainer;
        defaultTextColor = colorScheme.onErrorContainer;
        break;
    }

    return SizedBox(
      width: width,
      height: height ?? 50,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: theme.elevatedButtonTheme.style?.copyWith(
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? defaultBackgroundColor,
          ),
          foregroundColor: WidgetStateProperty.all(
            textColor ?? defaultTextColor,
          ),
          padding: WidgetStateProperty.all(
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
          ),
          elevation: WidgetStateProperty.all(elevation ?? 2),
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? defaultTextColor,
                    ),
                  ),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 8)],
                    Typography(
                      label,
                      variation: TypographyVariation.displaySmall,
                      color: textColor ?? defaultTextColor,
                    ),
                  ],
                ),
      ),
    );
  }
}
