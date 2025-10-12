import 'dart:ui';

import 'package:bartoo/app/modules/category/transformers/get_duration_and_price_from_service_list.dart';
import 'package:bartoo/app/modules/category/transformers/get_selected_services_from_category_list.dart';
import 'package:bartoo/app/modules/category/transformers/relate_services_to_categories.dart';
import 'package:core/data/models/appointment_datetime_model.dart';
import 'package:core/data/models/appointment_model.dart';
import 'package:core/data/models/artist_location_service_model.dart';
import 'package:core/data/models/artist_week_day_availability.dart';
import 'package:core/data/models/time_of_day.dart';
import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/category_service_model.dart';
import 'package:core/data/models/shared/duration_and_price_model.dart';
import 'package:core/modules/appointments/repository/appointment_repository.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:uuid/uuid.dart';

/// Schedule an appointment, show availability based in the artists availability and pending appointments
/// if in the current date there is no availability, select the next date
/// disable previous dates or next dates until having having availability

class ScheduleAppointmentController extends GetxController {
  final appointmentRepository = Get.find<AppointmentRepository>();
  late bool pendingAppointment = false;

  final Rx<bool> disablePrevButton = true.obs;
  final Rx<bool> disableNextButton = true.obs;
  final Rx<bool> onlyOneServiceSelected = true.obs;
  final Rx<bool> loadingArtistAvailabilty = false.obs;
  final Rx<bool> savingAppointment = false.obs;

  late Moment currentDate = Moment.now();
  final Rx<Moment> date = Moment.now().obs;
  final Rx<int?> time = Rxn<int>();
  final Rx<int> duration = 0.obs;
  final Rx<num> price = 0.obs;

  late List<AppointmentDatetimeModel>? artistPendingAppointments;

  final Rx<ArtistWeekDayAvailabilityModel?> currentDateAvailability =
      Rxn<ArtistWeekDayAvailabilityModel>();
  final RxList<TimeOfDayModel> currentTimesAvailability =
      <TimeOfDayModel>[].obs;
  late RxList<CategoryModel> categories = <CategoryModel>[].obs;

  late List<ArtistWeekDayAvailabilityModel> artistAbailability;
  late AppointmentModel appointment;
  late Function onAppointmentScheduled;

  /// initialize state based in an appointment
  void initializeAppointment(
    AppointmentModel initAppointment,
    Function initOnAppointmentScheduled,
  ) {
    appointment = initAppointment;
    pendingAppointment = initAppointment.state == AppointmentState.pending;
    onAppointmentScheduled = initOnAppointmentScheduled;
    artistPendingAppointments = null;

    initializeDate(
      initAppointment.startTime,
      null,
      // initAppointment.artist?.availability,
    );

    // initializeCategoriesAndServices(
    //   initAppointment.artist?.categories,
    //   initAppointment.artist?.services,
    // );
  }

  /// initialize date value and availability
  void initializeDate(
    DateTime? datetime,
    List<ArtistWeekDayAvailabilityModel>? availability,
  ) {
    // bool timeInitialized = false;
    // Moment dateForAvailability = date.value;
    // artistAbailability = availability ?? defaultWeekAvailability;

    // // if the datetime is set previously, set the date state
    // if (datetime != null) {
    //   dateForAvailability = Moment.parse(datetime.toIso8601String());
    //   // validate if the next or prev button must be disabled
    //   validateCurrentDatetime(null, dateForAvailability);

    //   date.value = dateForAvailability;

    //   // set the time state with the existing appointment time
    //   TimeOfDayModel? timeInList = getTimeByHour(
    //     dateForAvailability.formatTime(),
    //   );

    //   if (timeInList != null) {
    //     time.value = timeInList.id;

    //     // Indicate updateAvailabilityTimes function not to initialize time
    //     timeInitialized = true;
    //   }

    //   // print(date.value.format('hh:mm a'));
    // }

    // updateAvailabilityTimes(
    //   dateForAvailability,
    //   validateCurrentTime: true,
    //   timeInitialized: timeInitialized,
    // );
  }

  /// Relate artist´s services to categories.
  /// Set categories, duration and price in state
  void initializeCategoriesAndServices(
    List<CategoryModel>? artistCategories,
    List<ArtistLocationServiceModel>? artistServices,
  ) {
    List<CategoryModel> categoriesRelatedToServices =
        relateServicesToCategories(artistCategories, artistServices);

    categories.value = categoriesRelatedToServices;

    updateDurationAndPrice(categoriesRelatedToServices);
  }

  /// Update the services in a category, update duration and price
  void updateCategoryServices(
    String categoryId,
    List<CategoryServiceModel> services,
  ) {
    List<CategoryModel> newCategories =
        categories.map((category) {
          if (category.id == categoryId) {
            category.services = services;
          }

          return category;
        }).toList();

    categories.value = newCategories;

    updateDurationAndPrice(newCategories);
  }

  void updateDurationAndPrice(List<CategoryModel> newCategories) {
    List<CategoryServiceModel> preselectedServices =
        getSelectedServicesFromcategoryList(newCategories);

    DurationAndPriceModel initialDurationAndPrice =
        getDurationAndPriceFromServiceList(preselectedServices);

    onlyOneServiceSelected.value = preselectedServices.length <= 1;
    duration.value = initialDurationAndPrice.duration;
    price.value = initialDurationAndPrice.price;
  }

  /// it
  /// if in the current date the is no availability, increment the date and revalidate availability
  void updateAvailabilityTimes(
    Moment date, {
    // wether to get only time after the current time in the availability list
    bool validateCurrentTime = false,
    // wether the time state was already initialized and must not be updated in this function
    bool timeInitialized = false,
  }) async {
    // get the artist´s availability of the current date weekday from the artist availability
    ArtistWeekDayAvailabilityModel availability = artistAbailability.firstWhere(
      (availabilityDay) => availabilityDay.day == date.weekday,
    );

    // Get the available times list based on the artist´s availability  of the current weekday and get only times after the current time
    // List<TimeOfDayModel> timesAvailability = getTimesListByAvailability(
    //   availability,
    //   validateCurrentTime: validateCurrentTime,
    // );

    List<AppointmentDatetimeModel>? artistPendingAppointments =
        await getArtistPendingAppointments();

    if (artistPendingAppointments == null) return;

    // timesAvailability = filterTimesByArtistPendingAppointments(
    //   appointment.id,
    //   date,
    //   timesAvailability,
    //   artistPendingAppointments,
    // );

    // currentDateAvailability.value = availability;

    // if (timesAvailability.isNotEmpty) {
    //   currentTimesAvailability.value = timesAvailability;

    //   if (!timeInitialized) time.value = timesAvailability[0].id;
    // } else {
    //   updateDate(1, true, date);
    // }
  }

  void updateDate(int? increment, bool? incremetCurrent, Moment? newDate) {
    newDate = (newDate ?? date.value);

    if (increment != null) {
      newDate = newDate.add(Duration(days: increment));
      date.value = newDate;

      if (incremetCurrent == true) {
        currentDate = currentDate.add(Duration(days: increment));
      }

      bool validateCurrentTime = validateCurrentDatetime(currentDate, newDate);

      updateAvailabilityTimes(
        newDate,
        validateCurrentTime: validateCurrentTime,
      );
    }
  }

  bool validateCurrentDatetime(DateTime? current, DateTime? newDate) {
    current ??= DateTime.now();
    newDate ??= DateTime.now();

    bool validateCurrentTime = current.startOfDay() == newDate.startOfDay();

    disablePrevButton.value =
        current.startOfDay() == newDate.startOfDay() ||
        current.startOfDay().isAfter(newDate.startOfDay());

    disableNextButton.value = current.startOfDay().isAfter(
      newDate.startOfDay(),
    );

    return validateCurrentTime;
  }

  /// if artistPendingAppointments has not been fetched, fetch and return
  /// if artistPendingAppointments were already fetched, return them
  Future<List<AppointmentDatetimeModel>?> getArtistPendingAppointments() async {
    try {
      if (appointment.artist == null) {
        return null;
      }
      if (artistPendingAppointments != null) return artistPendingAppointments;

      loadingArtistAvailabilty.value = true;

      artistPendingAppointments = await appointmentRepository.pendingByArtist(
        appointment.artist!.id,
      );
      loadingArtistAvailabilty.value = false;

      return artistPendingAppointments;
    } catch (e) {
      loadingArtistAvailabilty.value = false;
      print("Load artist pending appointments error: ");
      print(e);
    }
    return null;
  }

  void saveAppointment() async {
    savingAppointment.value = true;

    try {
      if (appointment.id.isEmpty) appointment.id = const Uuid().v4();

      //  If the number is a multiple of 5, subtract one so that the availability does not take the item immediately after completion
      // appointment.duration =
      //     duration.value % 5 == 0 ? duration.value - 1 : duration.value;
      appointment.duration = duration.value;
      appointment.price = price.value;
      appointment.services = getSelectedServicesFromcategoryList(categories);

      // TimeOfDayModel startTime = getTimeById(time.value!);

      // Moment startDate =
      //     inputFormat
      //         .parse("${date.value.format("YYYY-MM-DD")} ${startTime.hour}")
      //         .toMoment();

      // appointment.startTime = startDate;
      // appointment.endTime = startDate.add(Duration(minutes: duration.value));

      await appointmentRepository.save(appointment);
      onAppointmentScheduled(appointment);

      savingAppointment.value = false;
    } catch (e) {
      savingAppointment.value = false;
      print("Save appointment error: ");
      print(e);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
    super.removeListener(listener);
  }
}
