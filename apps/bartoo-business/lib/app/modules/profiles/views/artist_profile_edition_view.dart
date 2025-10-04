import 'package:bartoo/app/modules/profiles/widgets/forms/artist_form.dart';
import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/modules/auth/controllers/business_auth_guard_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ArtistProfileEditionView extends StatelessWidget {
  ArtistProfileEditionView({super.key});

  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();
  @override
  Widget build(BuildContext context) {
    Get.find<BusinessAuthGuardController>();

    return Container(
      padding: const EdgeInsets.all(20),
      child: ArtistForm(currentArtist: authController.selectedArtist.value),
    );
  }
}
