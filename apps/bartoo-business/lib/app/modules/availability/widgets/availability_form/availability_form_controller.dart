import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ui/widgets/form/stepper_form_fields.dart';
import 'package:utils/log.dart';

import 'package:core/data/models/availability_template_model.dart';
import 'package:core/data/models/time_of_day.dart';
import 'package:core/data/models/week_day_availability.dart';
import 'package:core/modules/availability/providers/availability_template_provider.dart';
import 'package:core/modules/availability/providers/location_availability_provider.dart';
import 'package:core/modules/availability/providers/times_provider.dart';

enum AvailabilityFormStep { template, customize }

class AvailabilityFormController extends GetxController
    implements StepperFormController<Rx<AvailabilityFormStep>> {
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

  @override
  final currentStep = Rx<AvailabilityFormStep>(AvailabilityFormStep.template);

  @override
  bool get isLoading => loading.value;

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
        currentStep.value = AvailabilityFormStep.customize;
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

  // Stepper navigation
  @override
  void nextStep() {
    if (isLoading) return;
    switch (currentStep.value) {
      case AvailabilityFormStep.template:
        if (_validateTemplateStep()) {
          currentStep.value = AvailabilityFormStep.customize;
        }
        break;
      case AvailabilityFormStep.customize:
        _submitForm();
        break;
    }
  }

  bool _validateTemplateStep() {
    if (hasExistingAvailability) return true; // allow editing existing
    if (selectedTemplateId.value.isEmpty) return false;
    return true;
  }

  Future<void> _submitForm() async {
    loading.value = true;
    try {
      final payload = buildUpsertPayload();
      final updated = await _locationAvailabilityProvider.upsertLocationAvailability(
        profileId,
        locationId,
        payload,
      );
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
    final defaultStart = times.first;
    final defaultEnd = times.length > 1 ? times[1] : times.first;
    final slot = WeekdayAvailabilityModel(
      weekday: weekday,
      startTime: defaultStart,
      endTime: defaultEnd,
    );
    final List<WeekdayAvailabilityModel> list = [
      ...(editableAvailability[weekday] ?? <WeekdayAvailabilityModel>[]),
    ];
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
