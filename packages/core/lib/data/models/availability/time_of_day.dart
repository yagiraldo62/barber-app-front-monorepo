class TimeOfDayModel {
  int id;
  String hour;

  TimeOfDayModel({required this.id, required this.hour});

  factory TimeOfDayModel.fromJson(Map<String, dynamic> json) =>
      TimeOfDayModel(id: json['id'] as int, hour: json['hour'] as String);

  Map<String, dynamic> toJson() {
    return {'id': id, 'hour': hour};
  }
}
