import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:ui/layout/app_layout.dart';
import 'package:ui/widgets/cards/service_card.dart';
import 'package:ui/widgets/greet/greet.dart';
import 'package:ui/widgets/search/search_section.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<BusinessAuthController>();

    return AppLayout(
      body: LayoutBuilder(
        builder:
            (BuildContext context, BoxConstraints constraints) => Container(
              height: constraints.maxHeight,
              padding: const EdgeInsets.only(top: 7),
              child: Column(
                children: [
                  Obx(
                    () =>
                        authController.user.value != null
                            ? Column(
                              children: [
                                Greet(
                                  name:
                                      authController.user.value?.name?.split(
                                        " ",
                                      )[0] ??
                                      '',
                                ),
                                const SizedBox(height: 7),
                                ServiceCard(
                                  name: "Corte Agendado",
                                  time: "Hoy - 4:30 PM",
                                  button: ElevatedButton(
                                    onPressed: () {},
                                    child: const Row(
                                      children: [
                                        Icon(Icons.arrow_forward),
                                        SizedBox(width: 5),
                                        Text("Editar"),
                                      ],
                                    ),
                                  ),
                                  // bottom: const ArtistCard(),
                                ),
                              ],
                            )
                            : const SizedBox(),
                  ),
                  const SizedBox(height: 20),
                  const SearchSection(),
                ],
              ),
            ),
      ),
    );
  }
}
