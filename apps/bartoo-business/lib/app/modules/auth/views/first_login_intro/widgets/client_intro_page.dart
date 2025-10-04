import 'package:bartoo/app/modules/auth/controllers/business_auth_guard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientIntroPage extends StatelessWidget {
  const ClientIntroPage({super.key});

  static String title = '¿Estas buscando Artistas Esteticos?';

  static Widget image = Image.asset("/images/service.png", width: 300);

  @override
  Widget build(BuildContext context) {
    Get.find<BusinessAuthGuardController>();

    return const Column(
      children: [
        Text(
          "Llegaste al lugar indicado, encuentra tu barbero y maneja tu cita desde un solo lugar",
        ),
      ],
    );
  }
}
