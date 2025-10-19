import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typography/typography.dart';

class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final Color? textColor;
  final TypographyVariation? variation;
  final EdgeInsetsGeometry? padding;

  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.textColor,
    this.variation,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = textColor ?? Theme.of(context).colorScheme.primary;

    if (icon != null) {
      return TextButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: defaultColor,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        icon:
            isLoading
                ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(defaultColor),
                  ),
                )
                : icon!,
        label: Typography(
          label,
          variation: variation ?? TypographyVariation.bodyMedium,
          color: defaultColor,
        ),
      );
    }

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: defaultColor,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child:
          isLoading
              ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(defaultColor),
                ),
              )
              : Typography(
                label,
                variation: variation ?? TypographyVariation.labelMedium,
                color: defaultColor,
              ),
    );
  }
}
