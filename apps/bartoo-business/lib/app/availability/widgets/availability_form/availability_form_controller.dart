import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:utils/log.dart';

import 'package:core/data/models/availability_template_model.dart';
import 'package:core/data/models/time_of_day.dart';
import 'package:core/data/models/week_day_availability.dart';
import 'package:core/modules/availability/providers/availability_template_provider.dart';
import 'package:core/modules/availability/providers/location_availability_provider.dart';
import 'package:core/modules/availability/providers/times_provider.dart';

class AvailabilityFormController extends GetxController {
  AvailabilityFormController({
    required this.profileId,
    required this.locationId,
    this.onSavedCallback,
    this.scrollController,
    this.isCreation = true,
  });

  final String profileId;
  final String locationId;
  final void Function(List<WeekdayAvailabilityModel>)? onSavedCallback;
  final ScrollController? scrollController;
  final bool isCreation;

  // Providers
  late final AvailabilityTemplateProvider _templateProvider;
  late final LocationAvailabilityProvider _locationAvailabilityProvider;
  late final TimesProvider _timesProvider;

  // State
  final loading = false.obs;
  final animationsComplete = false.obs;
  final error = ''.obs;

  // Data
  final RxList<AvailabilityTemplateModel> templates =
      <AvailabilityTemplateModel>[].obs;
  final RxString selectedTemplateId = ''.obs;
  final RxList<TimeOfDayModel> times = <TimeOfDayModel>[].obs;

  final RxList<WeekdayAvailabilityModel> existingAvailability =
      <WeekdayAvailabilityModel>[].obs;

  // Editable availability grouped by weekday (1..7)
  final RxMap<int, List<WeekdayAvailabilityModel>> editableAvailability =
      <int, List<WeekdayAvailabilityModel>>{}.obs;

  bool get hasExistingAvailability => existingAvailability.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _ensureDependencies();
    _bootstrap();
  }

  void _ensureDependencies() {
    if (!Get.isRegistered<AvailabilityTemplateProvider>()) {
      Get.put(AvailabilityTemplateProvider());
    }
    if (!Get.isRegistered<LocationAvailabilityProvider>()) {
      Get.put(LocationAvailabilityProvider());
    }
    if (!Get.isRegistered<TimesProvider>()) {
      Get.put(TimesProvider());
    }

    _templateProvider = Get.find<AvailabilityTemplateProvider>();
    _locationAvailabilityProvider = Get.find<LocationAvailabilityProvider>();
    _timesProvider = Get.find<TimesProvider>();
  }

  Future<void> _bootstrap() async {
    loading.value = true;
    error.value = '';
    try {
      await Future.wait([
        _loadTimes(),
        _loadTemplates(),
        _loadExistingAvailability(),
      ]);

      if (hasExistingAvailability) {
        _setEditableFromExisting();
      } else {
        setEditableFromTemplate(templates.first);
      }

      // allow the UI button
      Future.delayed(const Duration(milliseconds: 100), () {
        animationsComplete.value = true;
      });
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> _loadTimes() async {
    final fetched = await _timesProvider.getTimes();
    times.assignAll(fetched);
  }

  Future<void> _loadTemplates() async {
    final fetched = await _templateProvider.getAvailabilityTemplates();
    templates.assignAll(fetched ?? []);
  }

  Future<void> _loadExistingAvailability() async {
    final fetched = await _locationAvailabilityProvider.getLocationAvailability(
      profileId,
      locationId,
    );
    existingAvailability.assignAll(fetched);
  }

  void _setEditableFromExisting() {
    editableAvailability.clear();
    for (final item in existingAvailability) {
      editableAvailability.putIfAbsent(
        item.weekday,
        () => <WeekdayAvailabilityModel>[],
      );
      final List<WeekdayAvailabilityModel> list = <WeekdayAvailabilityModel>[
        ...(editableAvailability[item.weekday] ?? <WeekdayAvailabilityModel>[]),
        item,
      ];
      editableAvailability[item.weekday] = list;
    }
  }

  void setEditableFromTemplate(AvailabilityTemplateModel template) {
    selectedTemplateId.value = template.id;
    editableAvailability.clear();
    editableAvailability.addAll(template.items);
  }

  void cancelTemplateSelection() {
    selectedTemplateId.value = '';
    if (hasExistingAvailability) {
      _setEditableFromExisting();
    }
  }

  Future<void> submitForm() async {
    loading.value = true;
    try {
      final payload = buildUpsertPayload();
      final updated = await _locationAvailabilityProvider
          .upsertLocationAvailability(profileId, locationId, payload);
      existingAvailability.assignAll(updated);
      _setEditableFromExisting();
      onSavedCallback?.call(updated);
    } catch (e) {
      Log('Availability upsert error: $e');
    } finally {
      loading.value = false;
    }
  }

  // Editable operations
  void addSlot(int weekday) {
    if (times.isEmpty) return;

    final List<WeekdayAvailabilityModel> existingSlots =
        editableAvailability[weekday] ?? <WeekdayAvailabilityModel>[];

    // Find the slot with the latest end time
    TimeOfDayModel defaultStart;
    TimeOfDayModel defaultEnd;

    if (existingSlots.isEmpty) {
      // If no slots exist, use first and second time from available times
      defaultStart = times.first;
      defaultEnd = times.length > 1 ? times[1] : times.first;
    } else {
      // Find the slot with the latest end time
      final latestSlot = existingSlots.reduce((current, next) {
        return current.endTime.id > next.endTime.id ? current : next;
      });

      // New slot starts where the latest slot ends
      defaultStart = latestSlot.endTime;

      // Find the next available time after the start time
      final startIndex = times.indexWhere((t) => t.id == defaultStart.id);
      if (startIndex >= 0 && startIndex < times.length - 1) {
        defaultEnd = times[startIndex + 1];
      } else {
        // If we're at the end, just use the same time (will be invalid but user can change it)
        defaultEnd = defaultStart;
      }
    }

    final slot = WeekdayAvailabilityModel(
      weekday: weekday,
      startTime: defaultStart,
      endTime: defaultEnd,
    );

    final List<WeekdayAvailabilityModel> list = [...existingSlots];
    list.add(slot);
    editableAvailability[weekday] = list;
  }

  void removeSlot(int weekday, int index) {
    final List<WeekdayAvailabilityModel> list = [
      ...(editableAvailability[weekday] ?? <WeekdayAvailabilityModel>[]),
    ];
    if (index < 0 || index >= list.length) return;
    list.removeAt(index);
    editableAvailability[weekday] = list;
  }

  void updateSlotStart(int weekday, int index, TimeOfDayModel value) {
    final List<WeekdayAvailabilityModel> list = [
      ...(editableAvailability[weekday] ?? <WeekdayAvailabilityModel>[]),
    ];
    if (index < 0 || index >= list.length) return;
    final s = list[index];
    list[index] = WeekdayAvailabilityModel(
      weekday: s.weekday,
      startTime: value,
      endTime: s.endTime,
    );
    editableAvailability[weekday] = list;
  }

  void updateSlotEnd(int weekday, int index, TimeOfDayModel value) {
    final List<WeekdayAvailabilityModel> list = [
      ...(editableAvailability[weekday] ?? <WeekdayAvailabilityModel>[]),
    ];
    if (index < 0 || index >= list.length) return;
    final s = list[index];
    list[index] = WeekdayAvailabilityModel(
      weekday: s.weekday,
      startTime: s.startTime,
      endTime: value,
    );
    editableAvailability[weekday] = list;
  }

  /// Checks if a time should be disabled for a specific slot
  ///
  /// For start time: disable times that overlap with other slots
  /// For end time: disable times that are before or equal to start time, or overlap with other slots
  bool isTimeDisabledForSlot({
    required int weekday,
    required int slotIndex,
    required TimeOfDayModel time,
    required bool isStartTime,
  }) {
    final slots = editableAvailability[weekday] ?? <WeekdayAvailabilityModel>[];
    if (slotIndex < 0 || slotIndex >= slots.length) return false;

    final currentSlot = slots[slotIndex];

    // For end time: must be after start time
    if (!isStartTime) {
      if (time.id <= currentSlot.startTime.id) {
        return true;
      }
    }

    // Check for overlaps with other slots
    for (int i = 0; i < slots.length; i++) {
      if (i == slotIndex) continue; // Skip the current slot

      final otherSlot = slots[i];
      final otherStart = otherSlot.startTime.id;
      final otherEnd = otherSlot.endTime.id;

      if (isStartTime) {
        // For start time: disable if it falls within another slot's range
        // or if it would cause the end time to overlap
        if (time.id >= otherStart && time.id < otherEnd) {
          return true;
        }
        // Also disable if the current end time would overlap
        if (currentSlot.endTime.id > otherStart && time.id < otherStart) {
          return true;
        }
      } else {
        // For end time: disable if it falls within another slot's range
        if (time.id > otherStart && time.id <= otherEnd) {
          return true;
        }
        // Also disable if it would cause overlap
        if (time.id > otherEnd && currentSlot.startTime.id < otherEnd) {
          return true;
        }
      }
    }

    return false;
  }

  List<Map<String, dynamic>> buildUpsertPayload() {
    final result = <Map<String, dynamic>>[];
    editableAvailability.forEach((weekday, list) {
      for (final s in list) {
        result.add({
          'weekday': weekday,
          'start_time_id': s.startTime.id,
          'end_time_id': s.endTime.id,
        });
      }
    });
    return result;
  }
}
