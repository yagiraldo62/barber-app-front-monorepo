import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bartoo/app/modules/appointments/controllers/schedule_appointment_controller.dart';

class ScheduleAppointmentUserInfo extends StatelessWidget {
  ScheduleAppointmentUserInfo({super.key});

  final ScheduleAppointmentController scheduleAppointmentController =
      Get.find<ScheduleAppointmentController>();

  @override
  Widget build(BuildContext context) {
    return Text("User info form");
    // ClientCard(user: scheduleAppointmentController.appointment.client!);
  }
}
