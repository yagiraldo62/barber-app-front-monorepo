import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/week_day_availability.dart';
import 'package:utils/log.dart';

class LocationAvailabilityProvider extends BaseProvider {
  /// Get location availability for a specific profile and location
  ///
  /// [profileId] - The profile ID
  /// [locationId] - The location ID
  ///
  /// Returns a list of [WeekdayAvailabilityModel]
  ///
  /// Example:
  /// ```dart
  /// final availability = await getLocationAvailability(
  ///   '1bf8be35-815a-4e34-abb8-487601fc653f',
  ///   '4f3d7f49-49be-4b4d-a714-203e7c679eff',
  /// );
  /// ```
  Future<List<WeekdayAvailabilityModel>> getLocationAvailability(
    String profileId,
    String locationId,
  ) async {
    final response = await get(
      '/profiles/$profileId/locations/$locationId/availability',
    );

    Log('GET /profiles/$profileId/locations/$locationId/availability');
    Log(response.body);

    if ((response.body?["ok"] ?? false) != true) {
      return [];
    }

    return response.body?["data"] != null
        ? WeekdayAvailabilityModel.listFromJson(response.body?["data"])
        : [];
  }

  /// Upsert (create or update) location availability
  ///
  /// [profileId] - The profile ID
  /// [locationId] - The location ID
  /// [availability] - List of availability slots. Each slot must have:
  ///   - weekday: Day of the week (1-7, where 1 = Monday)
  ///   - start_time_id: ID of the start time
  ///   - end_time_id: ID of the end time
  ///
  /// Returns updated list of [WeekdayAvailabilityModel] on success, empty list on failure
  ///
  /// Example:
  /// ```dart
  /// final availability = await upsertLocationAvailability(
  ///   '1bf8be35-815a-4e34-abb8-487601fc653f',
  ///   '4f3d7f49-49be-4b4d-a714-203e7c679eff',
  ///   [
  ///     {
  ///       'weekday': 1,
  ///       'start_time_id': 1,
  ///       'end_time_id': 2,
  ///     },
  ///     {
  ///       'weekday': 2,
  ///       'start_time_id': 1,
  ///       'end_time_id': 2,
  ///     }
  ///   ],
  /// );
  /// ```
  Future<List<WeekdayAvailabilityModel>> upsertLocationAvailability(
    String profileId,
    String locationId,
    List<Map<String, dynamic>> availability,
  ) async {
    final response = await put(
      '/profiles/$profileId/locations/$locationId/availability',
      {'availability': availability},
    );

    Log('PUT /profiles/$profileId/locations/$locationId/availability');
    Log(response.body);

    if ((response.body?["ok"] ?? false) != true) {
      return [];
    }

    return response.body?["data"] != null
        ? WeekdayAvailabilityModel.listFromJson(response.body?["data"])
        : [];
  }
}
