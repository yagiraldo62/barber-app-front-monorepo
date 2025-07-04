import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typography/typography.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).elevatedButtonTheme.style;
    return SizedBox(
      width: width,
      height: height ?? 50,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: theme?.copyWith(
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? Theme.of(context).primaryColor,
          ),
          foregroundColor: WidgetStateProperty.all(textColor ?? Colors.black),
          padding: WidgetStateProperty.all(
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.zero,
            ),
          ),
          elevation: WidgetStateProperty.all(
            elevation ?? theme.elevation?.resolve({}) ?? 2,
          ),
        ),
        child:
            isLoading
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 8)],
                    Typography(
                      label,
                      variation: TypographyVariation.displaySmall,
                      color: textColor ?? Colors.black87,
                    ),
                  ],
                ),
      ),
    );
  }
}
