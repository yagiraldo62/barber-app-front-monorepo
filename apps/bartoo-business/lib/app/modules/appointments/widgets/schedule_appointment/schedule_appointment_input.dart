import 'package:bartoo/app/modules/appointments/controllers/schedule_appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/button/selectable_button.dart';
import 'package:get/get.dart';
import 'package:utils/date_time/format_date_utils.dart';

class ScheduleAppointmentInput extends StatelessWidget {
  final ScheduleAppointmentController scheduleAppointmentController =
      Get.find<ScheduleAppointmentController>();

  ScheduleAppointmentInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    FormatDateUtils.formatToCalendar(
                      scheduleAppointmentController.date.value,
                    ),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => IconButton(
                            onPressed:
                                scheduleAppointmentController
                                        .disablePrevButton
                                        .value
                                    ? null
                                    : () => scheduleAppointmentController
                                        .updateDate(-1, false, null),
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Obx(
                          () => IconButton(
                            onPressed:
                                scheduleAppointmentController
                                        .disableNextButton
                                        .value
                                    ? null
                                    : () => scheduleAppointmentController
                                        .updateDate(1, false, null),
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    scheduleAppointmentController
                        .currentTimesAvailability
                        .length,
                padding: const EdgeInsets.only(top: 15),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2),
                    child: Obx(
                      () => SelectableButton(
                        onSelectionChange:
                            () =>
                                scheduleAppointmentController.time.value =
                                    scheduleAppointmentController
                                        .currentTimesAvailability[index]
                                        .id,
                        selected:
                            scheduleAppointmentController.time.value ==
                            scheduleAppointmentController
                                .currentTimesAvailability[index]
                                .id,
                        child: Text(
                          "hora",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
