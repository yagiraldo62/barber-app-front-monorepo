import 'package:utils/date_time/normalize_date.dart';
import 'package:core/data/models/appointment_datetime_model.dart';
import 'package:core/data/models/time_of_day.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';

List<TimeOfDayModel> filterTimesByArtistPendingAppointments(
  String appointmentId,
  DateTime date,
  List<TimeOfDayModel> timesList,
  List<AppointmentDatetimeModel> artistPendingAppointments,
) {
  // print({
  //   "appointment": artistPendingAppointments[0].toJson(),
  // });
  String formatedDate = date.toMoment().format("YYYY-MM-DD");
  return timesList.where((time) {
    final itemTime = inputFormat.parse("$formatedDate $time");
    return artistPendingAppointments.firstWhereOrNull(
          (appointment) =>
              isTimeBetweenAppointmentDateRange(itemTime, appointment) &&
              appointment.id != appointmentId,
        ) ==
        null;
  }).toList();
}

bool isTimeBetweenAppointmentDateRange(
  DateTime time,
  AppointmentDatetimeModel appointment,
) {
  time = normalizeDate(time);
  DateTime appointmentStartTime = normalizeDate(appointment.startTime);
  DateTime appointmentEndTime = normalizeDate(appointment.endTime);

  return (appointmentStartTime.isBefore(time) ||
          appointmentStartTime.isAtSameMomentAs(time)) &&
      (appointmentEndTime.isAfter(time));
  // return (appointmentStartTime.isBefore(time) ||
  //         appointmentStartTime.isAtSameMomentAs(time)) &&
  //     (appointmentEndTime.isAfter(time) ||
  //         appointmentEndTime.isAtSameMomentAs(time));
}
