import 'dart:convert';

import 'package:core/data/models/time_of_day.dart';

typedef Availability = Map<int, List<WeekdayAvailabilityModel>>;

class WeekdayAvailabilityModel {
  int weekday;
  TimeOfDayModel startTime;
  TimeOfDayModel endTime;

  WeekdayAvailabilityModel({
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });

  factory WeekdayAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return WeekdayAvailabilityModel(
      weekday: json['weekday'] as int,
      startTime: TimeOfDayModel.fromJson(json['start_time']),
      endTime: TimeOfDayModel.fromJson(json['end_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekday': weekday,
      'start_time':
          startTime.toJson(), // Assuming TimeOfDayModel has a toJson method
      'end_time':
          endTime.toJson(), // Assuming TimeOfDayModel has a toJson method
    };
  }

  Map<String, dynamic> toSimplifiedJson() {
    return {
      'weekday': weekday,
      'start_time': startTime.id, // Assuming TimeOfDayModel has a toJson method
      'end_time': endTime.id, // Assuming TimeOfDayModel has a toJson method
    };
  }

  static List<WeekdayAvailabilityModel> listFromJson(dynamic jsonData) =>
      jsonData != null
          ? ((jsonData.runtimeType == String ? json.decode(jsonData) : jsonData)
                  as List)
              .map(
                (availabilityItem) =>
                    WeekdayAvailabilityModel.fromJson(availabilityItem),
              )
              .toList()
          : [];
}
