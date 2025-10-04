import 'package:bartoo/app/modules/profiles/controllers/artist_appointments_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistAppointmentsToggleMenu extends StatelessWidget {
  ArtistAppointmentsToggleMenu({super.key});
  final ArtistAppointmentsMenuController artistAppointmentsMenuController =
      Get.find<ArtistAppointmentsMenuController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ToggleButtons(
        constraints: const BoxConstraints(minWidth: 100),
        borderRadius: BorderRadius.circular(10),
        borderWidth: 0,
        textStyle: Theme.of(context).textTheme.bodySmall,
        isSelected: artistAppointmentsMenuController.menuOptions,
        onPressed: (int index) {
          artistAppointmentsMenuController.selectMenuOption(index);
        },
        children: const <Widget>[
          Padding(padding: EdgeInsets.all(5), child: Text("Activos")),
          Padding(padding: EdgeInsets.all(5), child: Text("Historial")),
        ],
      ),
    );
  }
}
