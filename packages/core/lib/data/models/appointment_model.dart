import 'package:core/data/models/appointment_client_info_model.dart';
import 'package:core/data/models/appointment_datetime_model.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/category_service_model.dart';
import 'package:core/data/models/user_model.dart';

class AppointmentState {
  static const String pending = 'pending';
  static const String canceled = 'canceled';
  static const String finished = 'finished';
  static const String pendingToReschedule = 'pending_to_reschedule';
}

class AppointmentModel {
  late DateTime? startTime;
  late DateTime? endTime;

  late String id;
  late UserModel? client;
  late ProfileModel? artist;
  late AppointmentClientInfoModel? clientInfo;
  late String? state;
  late int? duration;
  late num? price;
  late List<CategoryServiceModel>? services = [];

  AppointmentModel({
    this.id = "",
    this.client,
    this.artist,
    this.clientInfo,
    this.state = AppointmentState.pending,
    this.startTime,
    this.endTime,
    this.duration,
    this.price,
    this.services,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> jsonData) {
    // print(jsonData);
    return AppointmentModel(
      id: jsonData['id'] as String? ?? "",
      client:
          jsonData['client'] != null
              ? UserModel.fromJson(jsonData['client'])
              : null,
      artist:
          jsonData['artist'] != null
              ? ProfileModel.fromJson(jsonData['artist'])
              : null,
      clientInfo:
          jsonData['client_info'] != null
              ? AppointmentClientInfoModel.fromJson(jsonData['client_info'])
              : null,
      state: jsonData['state'] ?? AppointmentState.pending,
      duration: jsonData['duration'] as int?,
      price: jsonData['price'] as num?,
      startTime: DateTime.parse(jsonData['start_time']),
      endTime: DateTime.parse(jsonData['end_time']),
      services: CategoryServiceModel.listFromJson(jsonData['services']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'start_time': startTime?.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
    'client': client?.toJson(),
    'clientPinfo': client?.toJson(),
    'artist': artist?.toJson(),
    'category_info': clientInfo?.toJson(),
    'state': state,
    'duration': duration,
    'price': price,
    'services': services?.map((service) => service.toJson()).toList(),
  };

  Map<String, dynamic> toDbJson() => {
    'id': id,
    'start_time': startTime?.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
    'client_id': client?.id,
    'artist_id': artist?.id,
    'client_info': clientInfo?.toJson(),
    'state': state,
    'duration': duration,
    'price': price,
  };

  AppointmentDatetimeModel get datetime => AppointmentDatetimeModel(
    id: id,
    startTime: startTime ?? DateTime.now(),
    endTime: endTime ?? DateTime.now(),
  );

  static List<AppointmentModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData
              .map((appointment) => AppointmentModel.fromJson(appointment))
              .toList()
          : [];

  static List<AppointmentDatetimeModel> getAppointmentsListDatetimes(
    List<AppointmentModel> appointments,
  ) => appointments.map((appointment) => appointment.datetime).toList();
}
