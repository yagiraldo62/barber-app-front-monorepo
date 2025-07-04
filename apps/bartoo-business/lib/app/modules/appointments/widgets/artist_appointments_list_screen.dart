import 'package:bartoo/app/modules/appointments/controllers/artist/artist_appointments_controller.dart';
import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistAppointmentsListScreen extends StatelessWidget {
  final bool active;
  final authController = Get.find<BusinessAuthController>();

  final ArtistAppointmentsController artistAppointmentsController;

  ArtistAppointmentsListScreen({
    super.key,
    this.active = true,
    required this.artistAppointmentsController,
  }) {
    if (authController.selectedArtist.value != null) {
      artistAppointmentsController.initializeAppointmets(
        authController.selectedArtist.value!.id,
        active: active,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(authController.selectedArtist.value?.name ?? 'Artist');
  }
}
