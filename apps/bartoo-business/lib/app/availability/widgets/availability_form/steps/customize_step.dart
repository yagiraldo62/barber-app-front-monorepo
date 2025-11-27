import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/data/models/time_of_day.dart';
import 'package:utils/date_time/format_date_utils.dart';
import 'package:ui/widgets/input/time_selector.dart';

import '../availability_form_controller.dart';

class CustomizeAvailabilityStep extends StatelessWidget {
  const CustomizeAvailabilityStep({super.key, required this.controller});
  final AvailabilityFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final times = controller.times.toList(growable: false);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Weekdays 1..7 (Mon..Sun)
          for (
            int weekday = DateTime.monday;
            weekday <= DateTime.sunday;
            weekday++
          ) ...[
            _DayEditor(weekday: weekday, controller: controller, times: times),
            const SizedBox(height: 12),
          ],
        ],
      );
    });
  }
}

class _DayEditor extends StatelessWidget {
  const _DayEditor({
    required this.weekday,
    required this.controller,
    required this.times,
  });

  final int weekday;
  final AvailabilityFormController controller;
  final List<TimeOfDayModel> times;

  @override
  Widget build(BuildContext context) {
    final dayName = FormatDateUtils.getWeekdayName(weekday);

    return Obx(() {
      final slots = controller.editableAvailability[weekday] ?? <dynamic>[];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dayName, style: Theme.of(context).textTheme.labelLarge),
              TextButton.icon(
                onPressed: () => controller.addSlot(weekday),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Añadir franja'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (slots.isEmpty)
            Text(
              'Sin disponibilidad',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    for (int i = 0; i < slots.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          top: i > 0 && i <= slots.length ? 16.0 : 0.0,
                        ),
                        child: _SlotEditor(
                          weekday: weekday,
                          index: i,
                          controller: controller,
                          times: times,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _SlotEditor extends StatelessWidget {
  const _SlotEditor({
    required this.weekday,
    required this.index,
    required this.controller,
    required this.times,
  });

  final int weekday;
  final int index;
  final AvailabilityFormController controller;
  final List<TimeOfDayModel> times;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final slots = controller.editableAvailability[weekday];
      if (slots == null || index >= slots.length) {
        return const SizedBox.shrink();
      }

      final slot = slots[index];

      return Row(
        children: [
          Expanded(
            child: TimeSelector(
              initialValue: times.firstWhere(
                (e) => e.id == slot.startTime.id,
                orElse: () => times.first,
              ),
              labelText: 'Inicio',
              availableTimes: times,
              isTimeDisabled:
                  (time) => controller.isTimeDisabledForSlot(
                    weekday: weekday,
                    slotIndex: index,
                    time: time,
                    isStartTime: true,
                  ),
              onChanged: (val) {
                controller.updateSlotStart(weekday, index, val);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TimeSelector(
              initialValue: times.firstWhere(
                (e) => e.id == slot.endTime.id,
                orElse: () => times.first,
              ),
              labelText: 'Fin',
              availableTimes: times,
              isTimeDisabled:
                  (time) => controller.isTimeDisabledForSlot(
                    weekday: weekday,
                    slotIndex: index,
                    time: time,
                    isStartTime: false,
                  ),
              onChanged: (val) {
                controller.updateSlotEnd(weekday, index, val);
              },
            ),
          ),
          IconButton(
            onPressed: () => controller.removeSlot(weekday, index),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar franja',
          ),
        ],
      );
    });
  }
}
