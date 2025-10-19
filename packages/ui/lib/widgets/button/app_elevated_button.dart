import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typography/typography.dart';

class AppElevatedButton extends StatelessWidget {
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
  final TypographyVariation? variation;

  const AppElevatedButton({
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
    this.variation,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = textColor ?? Theme.of(context).colorScheme.onPrimary;
    final defaultBgColor = backgroundColor ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: width,
      height: height,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultBgColor,
                foregroundColor: defaultTextColor,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                ),
                elevation: elevation,
              ),
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                      ),
                    )
                  : icon!,
              label: Typography(
                label,
                variation: variation ?? TypographyVariation.labelMedium,
                color: defaultTextColor,
              ),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultBgColor,
                foregroundColor: defaultTextColor,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                ),
                elevation: elevation,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                      ),
                    )
                  : Typography(
                      label,
                      variation: variation ?? TypographyVariation.labelMedium,
                      color: defaultTextColor,
                    ),
            ),
    );
  }
}
