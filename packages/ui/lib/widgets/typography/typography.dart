import 'package:flutter/material.dart';

enum TypographyVariation {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

class Typography extends StatelessWidget {
  final String text;
  final TypographyVariation? variation;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final Color? color;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final double? fontSize;

  const Typography(
    this.text, {
    super.key,
    this.variation,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.color,
    this.decoration,
    this.fontWeight,
    this.fontSize,
  });

  TextStyle? _getVariationStyle(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    switch (variation) {
      case TypographyVariation.displayLarge:
        return theme.displayLarge;
      case TypographyVariation.displayMedium:
        return theme.displayMedium;
      case TypographyVariation.displaySmall:
        return theme.displaySmall;
      case TypographyVariation.headlineLarge:
        return theme.headlineLarge;
      case TypographyVariation.headlineMedium:
        return theme.headlineMedium;
      case TypographyVariation.headlineSmall:
        return theme.headlineSmall;
      case TypographyVariation.titleLarge:
        return theme.titleLarge;
      case TypographyVariation.titleMedium:
        return theme.titleMedium;
      case TypographyVariation.titleSmall:
        return theme.titleSmall;
      case TypographyVariation.bodyLarge:
        return theme.bodyLarge;
      case TypographyVariation.bodyMedium:
        return theme.bodyMedium;
      case TypographyVariation.bodySmall:
        return theme.bodySmall;
      case TypographyVariation.labelLarge:
        return theme.labelLarge;
      case TypographyVariation.labelMedium:
        return theme.labelMedium;
      case TypographyVariation.labelSmall:
        return theme.labelSmall;
      default:
        return theme.bodyMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = _getVariationStyle(context);
    final customStyle = style?.copyWith(
      color: color,
      decoration: decoration,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );

    return Text(
      text,
      style:
          customStyle ??
          baseStyle?.copyWith(
            color: color,
            decoration: decoration,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
