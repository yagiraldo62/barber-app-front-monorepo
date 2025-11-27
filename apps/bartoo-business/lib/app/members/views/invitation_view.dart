import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/members/widgets/invitation/invitation_details.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utils/log.dart';

class InvitationView extends GetView {
  InvitationView({super.key});

  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();

  onResponded(bool accepted) {
    Log(
      'El usuario ha respondido a la invitación: ${accepted ? "Aceptada" : "Rechazada"}',
    );
    authController.refreshUser(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    // Obtener token del parámetro de ruta (invitation_token)
    final token =
        Get.parameters['token'] ??
        (Get.arguments as Map<String, dynamic>?)?['token'] ??
        '';

    Log('Token de invitación: $token');

    if (token.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Token de invitación no válido')),
      );
    }

    return InvitationDetails(token: token, onResponded: onResponded);
  }
}
