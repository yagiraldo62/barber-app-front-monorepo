import 'package:flutter/material.dart' hide Typography;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ui/widgets/typography/typography.dart';

class PhoneNumberInput extends StatelessWidget {
  final String? labelText;
  final String? initialPhone;
  final void Function(String e164)? onChanged;
  final void Function(bool isValid)? onValidated;
  final FocusNode? focusNode;

  const PhoneNumberInput({
    super.key,
    this.labelText,
    this.initialPhone,
    this.onChanged,
    this.onValidated,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Typography(
              labelText!,
              variation: TypographyVariation.displaySmall,
              fontWeight: FontWeight.w500,
            ),
          ),
        InternationalPhoneNumberInput(
          countries: const ['CO', 'US', 'VE', 'PE', 'AR', 'BR', 'MX'],
          initialValue: PhoneNumber(
            isoCode: 'CO',
            dialCode: '+57',
            phoneNumber: initialPhone ?? '',
          ),
          selectorTextStyle: textTheme.bodyMedium,
          textStyle: textTheme.bodyMedium,

          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.DROPDOWN,
            trailingSpace: false,
            useEmoji: true,
          ),
          focusNode: focusNode,
          onInputChanged: (PhoneNumber number) async {
            if (onChanged != null) {
              onChanged!(number.phoneNumber ?? '');
            }
          },
          onInputValidated: (bool value) {
            if (onValidated != null) onValidated!(value);
          },
          errorMessage: 'Número inválido',
          autoValidateMode: AutovalidateMode.onUserInteraction,
          formatInput: true,
          spaceBetweenSelectorAndTextField: 8,
          keyboardType: const TextInputType.numberWithOptions(signed: false),
          inputDecoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            hintText: '321 4567890',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}
