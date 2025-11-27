import 'package:core/data/models/appointment_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:core/modules/appointments/repository/appointment_repository.dart';

class ArtistAppointmentsController extends GetxController {
  final appointmentRepository = Get.find<AppointmentRepository>();
  final ScrollController scrollController = ScrollController();
  final String emptyStateText = "Aun no tienes ningun turno rgistrado";

  late String? _artistId;
  final int _perPage = 15;
  late int _page = 0;
  late bool _isLastPage = false;
  late bool _active = true;

  final Rx<bool> loading = false.obs;
  final RxMap<Moment, List<AppointmentModel>> appointmentsMap =
      <Moment, List<AppointmentModel>>{}.obs;

  void initializeAppointmets(String artistId, {bool active = true}) {
    _artistId = artistId;
    _active = active;
    loadAppointments();
  }

  void loadAppointments() async {
    try {
      if (_artistId == null || _isLastPage) return;

      loading.value = true;

      final from = (_page * _perPage);
      final to = from + _perPage - 1;

      List<AppointmentModel> appointments = await appointmentRepository
          .byArtist(_artistId!, from: from, to: to, active: _active);

      addAppointmentsToDatesMap(appointments);

      _isLastPage = appointments.length < _perPage;
      _page++;
      loading.value = false;
    } catch (e) {
      print(e);
    }
  }

  void addAppointmentsToDatesMap(List<AppointmentModel> appointments) {
    appointments.map((appointment) {
      Moment appointmentDate =
          Moment(
            appointment.startTime!,
            localization: MomentLocalizations.es(),
          ).startOfDay();
      if (appointmentsMap[appointmentDate] == null) {
        appointmentsMap[appointmentDate] = <AppointmentModel>[];
      }

      appointmentsMap[appointmentDate]!.add(appointment);
    }).toList();
  }

  @override
  void removeListener(VoidCallback listener) {
    scrollController.dispose();
    super.removeListener(listener);
  }
}

class ActiveArtistAppointmentsController extends ArtistAppointmentsController {
  @override
  bool get _active => true;

  @override
  String get emptyStateText => "No tienes turnos activos";
}

class ArtistAppointmentsHistoryController extends ArtistAppointmentsController {
  @override
  bool get _active => false;

  @override
  String get emptyStateText => "Aun no tienes ningun turno registrado";
}
