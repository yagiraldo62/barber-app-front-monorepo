import 'package:bartoo/app/appointments/controllers/artist/artist_appointments_controller.dart';
import 'package:bartoo/app/appointments/widgets/artist_appointments_list_screen.dart';
import 'package:bartoo/app/profiles/controllers/artist_appointments_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistAppointmentsNavigationStack extends StatelessWidget {
  ArtistAppointmentsNavigationStack({super.key});
  final artistAppointmentsMenuController =
      Get.find<ArtistAppointmentsMenuController>();

  final ActiveArtistAppointmentsController activeArtistAppointmentsController =
      Get.find<ActiveArtistAppointmentsController>();

  final ArtistAppointmentsHistoryController
  artistAppointmentsHistoryController =
      Get.find<ArtistAppointmentsHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IndexedStack(
        index: artistAppointmentsMenuController.selectedMenuOptionIndex.value,
        children: [
          ArtistAppointmentsListScreen(
            artistAppointmentsController: activeArtistAppointmentsController,
          ),
          ArtistAppointmentsListScreen(
            active: false,
            artistAppointmentsController: artistAppointmentsHistoryController,
          ),
        ],
      ),
    );
  }
}
