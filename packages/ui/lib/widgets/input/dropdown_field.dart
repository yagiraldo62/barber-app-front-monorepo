import 'package:flutter/material.dart' hide Typography;
import '../typography/typography.dart';

class CommonDropdownField<T> extends StatefulWidget {
  final String labelText;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final String? Function(T?)? validator;
  final FocusNode? focusNode;

  const CommonDropdownField({
    super.key,
    this.labelText = '',
    this.hintText = '',
    this.value,
    required this.items,
    this.onChanged,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.filled = true,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ),
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.validator,
    this.focusNode,
  });

  @override
  State<CommonDropdownField<T>> createState() => _CommonDropdownFieldState<T>();
}

class _CommonDropdownFieldState<T> extends State<CommonDropdownField<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Typography(
              widget.labelText,
              variation: TypographyVariation.displaySmall,
              fontWeight: FontWeight.w500,
            ),
          ),
        DropdownButtonFormField<T>(
          value: widget.value,
          hint:
              widget.hintText.isNotEmpty
                  ? Text(
                    widget.hintText,
                    style:
                        widget.hintStyle ??
                        Theme.of(context).textTheme.bodySmall,
                  )
                  : null,
          items: widget.items,
          onChanged: widget.enabled ? widget.onChanged : null,
          style: widget.textStyle ?? Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            fillColor: widget.fillColor,
            filled: widget.filled,
            contentPadding: widget.contentPadding,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
            ),
          ),
          validator: widget.validator,
          focusNode: widget.focusNode,
          isExpanded: true,
        ),
      ],
    );
  }
}
