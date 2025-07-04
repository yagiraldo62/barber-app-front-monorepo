import 'package:flutter/material.dart' hide Typography;
import '../typography/typography.dart';

class CommonTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextDirection? textDirection;
  final Function(String?)? onBlur; // Nuevo parámetro onBlur

  const CommonTextField({
    super.key,
    this.hintText = '',
    this.labelText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textStyle,
    this.hintStyle,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.fillColor,
    this.filled = true,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 2,
      vertical: 12,
    ),
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.validator,
    this.focusNode,
    this.textDirection = TextDirection.ltr,
    this.onBlur, // Añadido al constructor
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Inicializar el focusNode localmente si no se proporciona y onBlur está presente
    _focusNode =
        widget.focusNode ?? (widget.onBlur != null ? FocusNode() : FocusNode());

    if (widget.onBlur != null) {
      _focusNode.addListener(() {
        if (!_focusNode.hasFocus) {
          // Este código se ejecuta cuando el campo pierde el foco (onBlur)
          widget.onBlur!(widget.controller?.text);
        }
      });
    }
  }

  @override
  void dispose() {
    // Solo disponer del focusNode si lo creamos localmente
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

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
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          style: widget.textStyle ?? Theme.of(context).textTheme.bodySmall,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          readOnly: widget.readOnly,
          focusNode: _focusNode,
          textDirection: widget.textDirection,
          onEditingComplete:
              widget.onBlur != null
                  ? () {
                    // Esto se dispara cuando el usuario presiona "done/enter"
                    FocusScope.of(
                      context,
                    ).unfocus(); // Quita el foco explícitamente
                    widget.onBlur!(widget.controller?.text);
                  }
                  : null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle:
                widget.hintStyle ?? Theme.of(context).textTheme.bodySmall,
            contentPadding: widget.contentPadding,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          validator: widget.validator,
        ),
      ],
    );
  }
}
