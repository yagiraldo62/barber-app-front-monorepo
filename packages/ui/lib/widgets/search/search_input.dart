import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final bool autofocus;

  const SearchInput({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultFillColor = fillColor ?? 
        Theme.of(context).cardTheme.surfaceTintColor ?? 
        Theme.of(context).colorScheme.surface;
    
    final defaultBorderRadius = borderRadius ?? 10;
    
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      autofocus: autofocus,
      style: textStyle ?? const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        filled: true,
        fillColor: defaultFillColor,
        isDense: false,
        contentPadding: contentPadding ?? 
            const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10,
            ),
        hintText: hintText ?? "Search...",
        hintStyle: hintStyle ?? 
            const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 127, 127, 127),
            ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon ?? const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
