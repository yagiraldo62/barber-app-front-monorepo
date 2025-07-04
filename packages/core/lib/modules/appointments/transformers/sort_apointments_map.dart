import 'package:core/data/models/appointment/appointment_model.dart';
import 'package:moment_dart/moment_dart.dart';

Map<Moment, List<AppointmentModel>> sortAppointmentsMap(
  Map<Moment, List<AppointmentModel>> appointmentsMap, {
  bool ascending = true,
}) {
  Map<Moment, List<AppointmentModel>> sortedAppointmentsMap =
      <Moment, List<AppointmentModel>>{};

  List<Moment> appointmentsMapKeys = appointmentsMap.keys.toList();

  appointmentsMapKeys.sort(
    (a, b) => ascending ? a.compareTo(b) : b.compareTo(a),
  );

  for (Moment appointmentsMapKey in appointmentsMapKeys) {
    List<AppointmentModel> appointments = appointmentsMap[appointmentsMapKey]!;
    appointments.sort(
      (a, b) =>
          ascending
              ? a.startTime!.compareTo(b.startTime!)
              : b.startTime!.compareTo(a.startTime!),
    );
    sortedAppointmentsMap[appointmentsMapKey] = appointments;
  }

  return sortedAppointmentsMap;
}
