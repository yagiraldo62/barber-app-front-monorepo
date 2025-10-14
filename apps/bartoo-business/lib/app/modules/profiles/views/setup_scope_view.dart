import 'package:bartoo/app/modules/auth/controllers/business_auth_guard_controller.dart';
import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/layout/app_layout.dart';
import 'package:ui/widgets/typing_text/secuential_typing_messages.dart';

import 'package:bartoo/app/modules/profiles/widgets/setup_profile_flow.dart';

class SetupScopeView extends GetView {
  SetupScopeView({super.key});

  final BaseAuthController authController = Get.find<BaseAuthController>();
  final scrollController = ScrollController();
  final welcomeKey = GlobalKey<SequentialTypingMessagesState>();
  final showForm = false.obs;

  @override
  Widget build(BuildContext context) {
    Get.find<BusinessAuthGuardController>();

    return AppLayout(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: SetupScopeFlow(scrollController: scrollController),
        ),
      ),
    );
  }
}
