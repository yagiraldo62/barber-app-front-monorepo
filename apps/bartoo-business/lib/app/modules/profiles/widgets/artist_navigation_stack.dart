import 'package:bartoo/app/modules/profiles/controllers/artist_bottom_navigation_controller.dart';
import 'package:bartoo/app/modules/appointments/widgets/artist_appointments_screen.dart';
import 'package:bartoo/app/modules/profiles/views/profile_edition_view.dart';
import 'package:bartoo/app/modules/profiles/widgets/artist_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistNavigationStack extends StatelessWidget {
  ArtistNavigationStack({super.key});
  final artistBottomNavigationController =
      Get.find<ArtistBottomNavigationController>();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => IndexedStack(
          index: artistBottomNavigationController.selectedIndex.value,
          children: [
            ArtistHomeScreen(),
            ArtistAppointmentsScreen(),
            // ArtistProfileEditionView(),
          ],
        ),
      ),
    );
  }
}
