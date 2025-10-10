class AppointmentClientInfoModel {
  String? name;
  String? phoneNumber;

  AppointmentClientInfoModel({this.name, this.phoneNumber});

  factory AppointmentClientInfoModel.fromJson(Map<String, dynamic> json) {
    return AppointmentClientInfoModel(
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
