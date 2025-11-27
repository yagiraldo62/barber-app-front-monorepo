import 'package:bartoo/app/profiles/controllers/artist_bottom_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/avatar/auth_user_avatar.dart';
import 'package:get/get.dart';

class ArtistBottomNavigationBar extends StatelessWidget {
  ArtistBottomNavigationBar({super.key});

  final artistBottomNavigationController =
      Get.isRegistered<ArtistBottomNavigationController>()
          ? Get.find<ArtistBottomNavigationController>()
          : Get.put(ArtistBottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: artistBottomNavigationController.selectedIndex.value,
        onTap: artistBottomNavigationController.onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Liquidador',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),

            //  icon: SizedBox(
            //   width: 30,
            //   height: 30,
            //    child: AuthUserAvatar(alternativeWidget: Icon(Icons.home)),
            // ),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
