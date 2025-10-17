import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/time_of_day.dart';
import 'package:utils/log.dart';

class TimesProvider extends BaseProvider {
  /// Get all available time slots
  ///
  /// Returns a list of [TimOfDayModel] with all available time slots
  ///
  /// Example:
  /// ```dart
  /// final times = await getTimes();
  /// ```
  Future<List<TimeOfDayModel>> getTimes() async {
    final response = await get('/times');

    Log('GET /times');
    Log(response.body);

    if ((response.body?["ok"] ?? false) != true) {
      return [];
    }

    return response.body?["data"] != null
        ? (response.body?["data"] as List)
            .map((json) => TimeOfDayModel.fromJson(json))
            .toList()
        : [];
  }
}
