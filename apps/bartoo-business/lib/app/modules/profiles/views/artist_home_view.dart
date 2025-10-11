import 'package:bartoo/app/modules/profiles/controllers/artist_bottom_navigation_controller.dart';
import 'package:bartoo/app/modules/profiles/widgets/artist_bottom_navigation_bar.dart';
import 'package:bartoo/app/modules/profiles/widgets/artist_navigation_stack.dart';
import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:ui/layout/app_layout.dart';
import 'package:get/get.dart';

class ArtistHomeView extends StatelessWidget {
  ArtistHomeView({super.key});
  final authController = Get.find<BaseAuthController>();
  final artistBottomNavigationController =
      Get.find<ArtistBottomNavigationController>();
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: LayoutBuilder(
        builder:
            (BuildContext context, BoxConstraints constraints) => Container(
              height: constraints.maxHeight,
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                children: [
                  // Obx(
                  //   () =>
                  //       authController.user.value != null
                  //           ? ArtistNavigationStack()
                  //           : const SizedBox(),
                  // ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      ),
      bottomNavigationBar: ArtistBottomNavigationBar(),
    );
  }
}
