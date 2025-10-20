import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/selector/common_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:base/constants/times_contants.dart';

class TimeSelector extends StatelessWidget {
  final TimeOfDayModel? initialValue;
  final Function(TimeOfDayModel) onChanged;
  final double? width;
  final double? height;
  final String labelText;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final List<TimeOfDayModel>? availableTimes;
  final bool Function(TimeOfDayModel)? isTimeDisabled;

  TimeSelector({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.width,
    this.height,
    this.labelText = 'Hora',
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.availableTimes,
    this.isTimeDisabled,
  }) {
    // Initialize with the initial value or first time from array
    final times = availableTimes ?? hoursArray;
    _selectedTime.value = initialValue ?? times.first;
    _textController.text = _selectedTime.value.format12Hour();
  }

  // Reactive state for selected time
  final Rx<TimeOfDayModel> _selectedTime = Rx<TimeOfDayModel>(
    TimeOfDayModel(id: 1, time: const TimeOfDay(hour: 0, minute: 0)),
  );

  // Text controller for the field
  final TextEditingController _textController = TextEditingController();

  // Show the time picker dialog
  void _showTimePicker(BuildContext context) {
    final times = availableTimes ?? hoursArray;

    CommonSelector.show<TimeOfDayModel>(
      context: context,
      title: 'Seleccionar hora',
      icon: Icons.access_time,
      items: times,
      selectedItem: _selectedTime.value,
      isItemDisabled: isTimeDisabled,
      itemBuilder: (context, time, isSelected) {
        final theme = Theme.of(context);
        final isDisabled = isTimeDisabled?.call(time) ?? false;

        return ListTile(
          enabled: !isDisabled,
          leading: Icon(
            Icons.schedule_outlined,
            color:
                isDisabled
                    ? theme.colorScheme.onSurface.withOpacity(0.3)
                    : isSelected
                    ? theme.colorScheme.primary
                    : null,
          ),
          title: Text(
            time.format12Hour(),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color:
                  isDisabled
                      ? theme.colorScheme.onSurface.withOpacity(0.3)
                      : isSelected
                      ? theme.colorScheme.primary
                      : null,
            ),
          ),
          trailing:
              isSelected
                  ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                  : null,
          tileColor:
              isSelected
                  ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                  : null,
        );
      },
      onItemSelected: (time) {
        _selectedTime.value = time;
        _textController.text = time.format12Hour();
        onChanged(time);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      // Update the text if selected time changes
      if (_textController.text != _selectedTime.value.format12Hour()) {
        _textController.text = _selectedTime.value.format12Hour();
      }

      return CommonTextField(
        controller: _textController,
        labelText: labelText,
        readOnly: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        onTap: () => _showTimePicker(context),
        prefixIcon: Icon(Icons.access_time, color: theme.colorScheme.onSurface),
      );
    });
  }
}
