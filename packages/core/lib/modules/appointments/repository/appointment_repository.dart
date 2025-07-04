import 'package:core/data/models/appointment/appointment_datetime_model.dart';
import 'package:core/data/models/appointment/appointment_model.dart';

class AppointmentRepository {
  Future<AppointmentModel?> find(String id) async {
    const data = null;

    if (data != null) {
      return AppointmentModel.fromJson(data);
    }
    return null;
  }

  Future<AppointmentModel> save(AppointmentModel appointment) async {
    return appointment;
  }

  Future<List<AppointmentModel>> byArtist(
    String artistId, {
    int from = 1,
    int to = 10,
    active = true,
  }) async {
    return AppointmentModel.listFromJson([]);
  }

  Future<List<AppointmentDatetimeModel>> pendingByArtist(
    String artistId,
  ) async {
    return AppointmentDatetimeModel.listFromJson([]);
  }
}
