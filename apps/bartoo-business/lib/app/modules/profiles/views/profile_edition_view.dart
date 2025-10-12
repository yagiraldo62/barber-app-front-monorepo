import 'package:bartoo/app/modules/profiles/widgets/forms/profile_form.dart';
import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/modules/auth/controllers/business_auth_guard_controller.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProfileEditionView extends StatelessWidget {
  ProfileEditionView({super.key});

  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();
  @override
  Widget build(BuildContext context) {
    Get.find<BusinessAuthGuardController>();

    if (authController.selectedScope.value is ProfileModel == false) {
      return const Scaffold(body: Center(child: Text('No profile found')));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: ProfileForm(
        currentProfile: authController.selectedScope.value as ProfileModel,
        isCreation: false,
      ),
    );
  }
}
