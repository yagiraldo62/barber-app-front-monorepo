import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typography/typography.dart';

class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final double? borderWidth;

  const AppOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.textColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = textColor ?? Theme.of(context).colorScheme.primary;
    final defaultBorderColor = borderColor ?? Theme.of(context).colorScheme.outline;

    return SizedBox(
      width: width,
      height: height,
      child: icon != null
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: defaultColor,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: defaultBorderColor,
                  width: borderWidth ?? 1,
                ),
              ),
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(defaultColor),
                      ),
                    )
                  : icon!,
              label: Typography(
                label,
                variation: TypographyVariation.labelMedium,
                color: defaultColor,
              ),
            )
          : OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: defaultColor,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: defaultBorderColor,
                  width: borderWidth ?? 1,
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(defaultColor),
                      ),
                    )
                  : Typography(
                      label,
                      variation: TypographyVariation.labelMedium,
                      color: defaultColor,
                    ),
            ),
    );
  }
}
