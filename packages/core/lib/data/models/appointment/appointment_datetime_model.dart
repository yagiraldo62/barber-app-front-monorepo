class AppointmentDatetimeModel {
  final String id;
  final DateTime startTime;
  final DateTime endTime;

  AppointmentDatetimeModel({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  factory AppointmentDatetimeModel.fromJson(Map<String, dynamic> jsonData) =>
      AppointmentDatetimeModel(
        id: jsonData['id'] as String? ?? "",
        startTime: DateTime.parse(jsonData['start_time']),
        endTime: DateTime.parse(jsonData['end_time']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime.toIso8601String(),
  };

  static List<AppointmentDatetimeModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData
              .map(
                (appointment) => AppointmentDatetimeModel.fromJson(appointment),
              )
              .toList()
          : [];
}
