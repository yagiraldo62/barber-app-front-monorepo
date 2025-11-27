// import 'package:bartoo/app/appointments/transformers/get_widgets_list_from_appointments_map.dart';
// import 'package:core/data/models/appointment_model.dart';
// import 'package:flutter/material.dart';
// import 'package:moment_dart/moment_dart.dart';

// class AppointmentsList extends StatelessWidget {
//   final Map<Moment, List<AppointmentModel>> appointmentsMap;
//   final ScrollController scrollController;
//   final bool loading;
//   final String emptyStateText;
//   final bool active;

//   const AppointmentsList({
//     super.key,
//     required this.appointmentsMap,
//     required this.scrollController,
//     required this.loading,
//     this.active = true,
//     this.emptyStateText = "Aun no tienes ningun turno registrado",
//   });

//   @override
//   Widget build(BuildContext context) {
//     Map<Moment, List<AppointmentModel>> sortedAppointmentsMap =
//         sortAppointmentsMap(appointmentsMap, ascending: active);

//     final List<Widget> appointmentsListWidgets =
//         getWidgetsListFromAppointmentsMap(sortedAppointmentsMap, context);

//     if (loading && appointmentsListWidgets.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (appointmentsListWidgets.isEmpty) {
//       return Center(child: Text(emptyStateText));
//     }

//     return ListView(
//       padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
//       shrinkWrap: true,
//       children: appointmentsListWidgets,
//     );
//   }
// }
