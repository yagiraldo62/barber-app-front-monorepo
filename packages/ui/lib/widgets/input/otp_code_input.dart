import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpCodeInput extends StatefulWidget {
  final int length;
  final void Function(String value)? onCompleted;
  final void Function(String value)? onChanged;

  const OtpCodeInput({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpCodeInput> createState() => _OtpCodeInputState();
}

class _OtpCodeInputState extends State<OtpCodeInput> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String getOtpValue() {
    return controllers.map((c) => c.text).join();
  }

  void handleChange(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    }

    final otpValue = getOtpValue();
    widget.onChanged?.call(otpValue);

    if (otpValue.length == widget.length) {
      widget.onCompleted?.call(otpValue);
    }
  }

  void handleBackspace(int index) {
    if (index > 0 && controllers[index].text.isEmpty) {
      focusNodes[index - 1].requestFocus();
      controllers[index - 1].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          margin: EdgeInsets.only(right: index < widget.length - 1 ? 10 : 0),
          width: 48,
          height: 56,
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: theme.textTheme.displaySmall,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: theme.colorScheme.primaryContainer,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => handleChange(index, value),
            onTap: () {
              if (controllers[index].text.isNotEmpty) {
                controllers[index].selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controllers[index].text.length,
                );
              }
            },
            onEditingComplete: () {
              if (index < widget.length - 1) {
                focusNodes[index + 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
