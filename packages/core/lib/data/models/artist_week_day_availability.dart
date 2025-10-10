import 'package:core/data/models/time_of_day.dart';

class ArtistWeekDayAvailabilityModel {
  int day;
  TimeOfDayModel startTime;
  TimeOfDayModel endTime;

  ArtistWeekDayAvailabilityModel({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  // factory ArtistWeekDayAvailabilityModel.fromJson(Map<String, dynamic> json) {
  //   // print(json);
  //   // print(ArtistWeekDayAvailabilityModel(
  //   //   day: json['day'] as int,
  //   //   startTime: getTimeById(json['start_time']['id'] as int? ?? 1),
  //   //   endTime: getTimeById(json['end_time']['id'] as int? ?? timesList.length),
  //   // ).toJson());
  //   return ArtistWeekDayAvailabilityModel(
  //     day: json['day'] as int,
  //     startTime: getTimeById(json['start_time']['id'] as int? ?? 1),
  //     endTime: getTimeById(json['end_time']['id'] as int? ?? timesList.length),
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'start_time':
          startTime.toJson(), // Assuming TimeOfDayModel has a toJson method
      'end_time':
          endTime.toJson(), // Assuming TimeOfDayModel has a toJson method
    };
  }

  Map<String, dynamic> toSimplifiedJson() {
    return {
      'day': day,
      'start_time': startTime.id, // Assuming TimeOfDayModel has a toJson method
      'end_time': endTime.id, // Assuming TimeOfDayModel has a toJson method
    };
  }

  //   static List<ArtistWeekDayAvailabilityModel> listFromJson(dynamic jsonData) =>
  //       jsonData != null
  //           ? ((jsonData.runtimeType == String ? json.decode(jsonData) : jsonData)
  //                   as List)
  //               .map(
  //                 (availabilityItem) =>
  //                     ArtistWeekDayAvailabilityModel.fromJson(availabilityItem),
  //               )
  //               .toList()
  //           : [];
  // }
}
