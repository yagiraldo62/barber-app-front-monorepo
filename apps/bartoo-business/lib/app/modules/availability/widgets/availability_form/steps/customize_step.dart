import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/data/models/time_of_day.dart';
import 'package:utils/date_time/format_date_utils.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personaliza tu disponibilidad',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton.icon(
                onPressed: () {
                  controller.currentStep.value = AvailabilityFormStep.template;
                },
                icon: const Icon(Icons.content_copy),
                label: const Text('Seleccionar plantilla'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          // Weekdays 1..7 (Mon..Sun)
          for (int weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++) ...[
            _DayEditor(
              weekday: weekday,
              controller: controller,
              times: times,
            ),
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
    final slots = controller.editableAvailability[weekday] ?? <dynamic>[];
    final dayName = FormatDateUtils.getWeekdayName(weekday);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dayName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          )
        else
          Column(
            children: [
              for (int i = 0; i < slots.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _SlotEditor(
                    weekday: weekday,
                    index: i,
                    controller: controller,
                    times: times,
                  ),
                ),
            ],
          ),
      ],
    );
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
    final slot = controller.editableAvailability[weekday]![index];

    String format(TimeOfDayModel t) {
      final h = t.time.hour.toString().padLeft(2, '0');
      final m = t.time.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<TimeOfDayModel>(
            value: times.firstWhere(
              (e) => e.id == slot.startTime.id,
              orElse: () => times.first,
            ),
            items: times
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(format(t)),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) controller.updateSlotStart(weekday, index, val);
            },
            decoration: const InputDecoration(labelText: 'Inicio'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<TimeOfDayModel>(
            value: times.firstWhere(
              (e) => e.id == slot.endTime.id,
              orElse: () => times.first,
            ),
            items: times
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(format(t)),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) controller.updateSlotEnd(weekday, index, val);
            },
            decoration: const InputDecoration(labelText: 'Fin'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => controller.removeSlot(weekday, index),
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Eliminar franja',
        ),
      ],
    );
  }
}
