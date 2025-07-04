// import 'package:ui/widgets/button/selectable_entity_button.dart';
// import 'package:ui/widgets/cards/service_card.dart';
// import 'package:core/data/models/appointment/appointment_model.dart';
// import 'package:flutter/material.dart';
// import 'package:moment_dart/moment_dart.dart';

// List<Widget> getWidgetsListFromAppointmentsMap(
//   Map<Moment, List<AppointmentModel>> appointmentsMap,
//   BuildContext context,
// ) => appointmentsMap.keys.fold(<Widget>[], (
//   List<Widget> appointmentsListWidgets,
//   Moment appointmentsMapKey,
// ) {
//   appointmentsListWidgets.addAll([
//     Text(appointmentsMapKey.calendar(omitHours: true)),
//     const SizedBox(height: 8),
//     ...appointmentsMap[appointmentsMapKey]!.map((appointment) {
//       appointment.services =
//           (appointment.services ?? []).map((service) {
//             service.selected = false;
//             return service;
//           }).toList();

//       return ServiceCard(
//         name: appointment.client?.name ?? appointment.clientInfo?.name ?? "",
//         time:
//             "${Moment(appointment.startTime!).formatTime()} - ${Moment(appointment.endTime!).formatTime()}",
//         button: ElevatedButton(
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               builder:
//                   (context) => ScheduleAppointment(
//                     isClient: false,
//                     appointment: appointment,
//                     onAppointmentScheduled: () {},
//                   ),
//             );
//           },
//           child: const Row(
//             children: [
//               Icon(Icons.arrow_forward),
//               SizedBox(width: 5),
//               Text("Editar"),
//             ],
//           ),
//         ),
//         bottom: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: selectableEntityButtonList(
//               appointment.services ?? [],
//               null,
//               showName: false,
//               size: 25,
//               spacing: 8,
//             ),
//           ),
//         ),
//       );
//     }),
//     const SizedBox(height: 12),
//   ]);

//   return appointmentsListWidgets;
// });
