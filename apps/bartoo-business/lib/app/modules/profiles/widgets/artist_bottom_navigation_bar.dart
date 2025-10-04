import 'package:bartoo/app/modules/profiles/controllers/artist_bottom_navigation_controller.dart';
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
        currentIndex: artistBottomNavigationController.selectedIndex.value,
        onTap: artistBottomNavigationController.onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_rounded),
            label: 'Turnos',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: AuthUserAvatar(
                isArtist: true,
                alternativeWidget: Icon(Icons.home),
              ),
            ),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
