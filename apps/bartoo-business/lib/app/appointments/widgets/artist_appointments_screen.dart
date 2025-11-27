import 'package:bartoo/app/appointments/controllers/artist/artist_appointments_controller.dart';
import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/locations/widgets/no_locations_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistAppointmentsScreen extends StatelessWidget {
  ArtistAppointmentsScreen({super.key});
  final authController = Get.find<BusinessAuthController>();

  final ActiveArtistAppointmentsController activeArtistAppointmentsController =
      Get.find<ActiveArtistAppointmentsController>();

  final ArtistAppointmentsHistoryController
  artistAppointmentsHistoryController =
      Get.find<ArtistAppointmentsHistoryController>();

  @override
  Widget build(BuildContext context) {
    return NoLocationsAlert();

    // if (!authController.hasSelectedArtistLocations()) {
    //   return NoLocationsAlert();
    // }

    // return Column(
    //   children: [
    //     // UserGreet(
    //     //   size: 24,
    //     //   name: authController.user.value?.name?.split(" ")[0],
    //     //   padding: const EdgeInsets.only(left: 24, right: 24),
    //     // ),
    //     Container(
    //       padding: const EdgeInsets.only(left: 10),
    //       alignment: Alignment.centerLeft,
    //       child: Text(
    //         "Turnos",
    //         style: Theme.of(context).textTheme.headlineMedium,
    //       ),
    //     ),
    //     const SizedBox(height: 15),
    //     Container(
    //       padding: const EdgeInsets.all(12),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           ArtistAppointmentsToggleMenu(),
    //           ElevatedButton(
    //             onPressed: () {
    //               showModalBottomSheet(
    //                 context: context,
    //                 isScrollControlled: true,
    //                 builder:
    //                     (context) => ScheduleAppointment(
    //                       isClient: false,
    //                       appointment: AppointmentModel(
    //                         artist: authController.selectedScope.value!,
    //                       ),
    //                       onAppointmentScheduled: (
    //                         AppointmentModel appointment,
    //                       ) {
    //                         activeArtistAppointmentsController.loading.value =
    //                             true;
    //                         artistAppointmentsHistoryController.loading.value =
    //                             true;

    //                         activeArtistAppointmentsController
    //                             .addAppointmentsToDatesMap([appointment]);
    //                         artistAppointmentsHistoryController
    //                             .addAppointmentsToDatesMap([appointment]);

    //                         activeArtistAppointmentsController.loading.value =
    //                             false;
    //                         artistAppointmentsHistoryController.loading.value =
    //                             false;

    //                         Get.back();
    //                       },
    //                     ),
    //               );
    //             },
    //             child: const Row(
    //               children: [
    //                 Icon(Icons.add),
    //                 SizedBox(width: 5),
    //                 Text("Agendar"),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Expanded(child: ArtistAppointmentsNavigationStack()),

    //     // const SizedBox(
    //     //   height: 7,
    //     // ),
    //     // ServiceCard(
    //     //   name: "Siguente turno",
    //     //   time: "En 8 min",
    //     //   button: ElevatedButton(
    //     //     onPressed: () {},
    //     //     child: const Row(
    //     //       children: [
    //     //         Icon(Icons.arrow_forward),
    //     //         SizedBox(width: 5),
    //     //         Text("Editar"),
    //     //       ],
    //     //     ),
    //     //   ),
    //     //   bottom: ArtistCard(),
    //     // )
    //   ],
    // );
  }
}
