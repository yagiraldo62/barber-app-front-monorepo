import 'package:flutter/material.dart';

const int timesInterval = 15;

List<TimeOfDayModel> generateHoursArray(int intervalMinutes) {
  final List<TimeOfDayModel> result = [];

  // Generate time array for a 24-hour day
  DateTime currentTime = DateTime(0, 1, 1, 0, 0); // start from midnight
  final DateTime endTime = DateTime(
    0,
    1,
    1,
    24,
    0,
  ); // end at midnight of next day

  int id = 1;

  while (currentTime.isBefore(endTime)) {
    // Create a TimeOfDayModel with id and TimeOfDay
    final timeObject = TimeOfDayModel(
      id: id,
      time: TimeOfDay(hour: currentTime.hour, minute: currentTime.minute),
    );

    result.add(timeObject);

    // Increment to the next time and id
    currentTime = currentTime.add(Duration(minutes: intervalMinutes));
    id++;
  }

  return result;
}

final List<TimeOfDayModel> hoursArray = generateHoursArray(timesInterval);

class TimeOfDayModel {
  final int id;
  final TimeOfDay time;

  const TimeOfDayModel({required this.id, required this.time});

  /// Formats the time in 12-hour format with AM/PM
  /// Example: 14:30 -> 2:30 PM
  String format12Hour() {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Formats the time in 24-hour format
  /// Example: 14:30 -> 14:30
  String format24Hour() {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Parses a time string in "HH:mm:ss" format and returns a TimeOfDay object
  static TimeOfDay timeFromString(String timeString) {
    final parts = timeString.split(':');
    if (parts.length < 2) {
      throw FormatException('Invalid time format: $timeString');
    }

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  Map<String, dynamic> toJson() {
    final String formattedTime =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:00';

    return {'id': id, 'time': formattedTime};
  }

  factory TimeOfDayModel.fromJson(Map<String, dynamic> json) {
    final timeData = json['time'];
    TimeOfDay parsedTime;

    if (timeData is String) {
      // Parse from string format "HH:mm:ss"
      parsedTime = timeFromString(timeData);
    } else if (timeData is Map<String, dynamic>) {
      // Parse from object format {hour: x, minute: y}
      parsedTime = TimeOfDay(
        hour: (timeData['hour'] as int?) ?? 0,
        minute: (timeData['minute'] as int?) ?? 0,
      );
    } else {
      throw FormatException('Invalid time format in JSON');
    }

    return TimeOfDayModel(id: json['id'] as int, time: parsedTime);
  }
}
