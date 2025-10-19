import 'package:flutter/material.dart';

/// Formats a TimeOfDay to 12-hour format with AM/PM
/// Example: 14:30 -> 2:30 PM
String formatTime12Hour(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

/// Formats a TimeOfDay to 12-hour format with lowercase am/pm
/// Example: 14:30 -> 2:30 pm
String formatTime12HourLowercase(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'am' : 'pm';
  return '$hour:$minute $period';
}

/// Formats a TimeOfDay to 24-hour format
/// Example: 14:30 -> 14:30
String formatTime24Hour(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

/// Extension on TimeOfDay for easier formatting
extension TimeOfDayFormatting on TimeOfDay {
  /// Formats to 12-hour format with AM/PM
  String to12HourFormat() => formatTime12Hour(this);

  /// Formats to 12-hour format with lowercase am/pm
  String to12HourFormatLowercase() => formatTime12HourLowercase(this);

  /// Formats to 24-hour format
  String to24HourFormat() => formatTime24Hour(this);
}
