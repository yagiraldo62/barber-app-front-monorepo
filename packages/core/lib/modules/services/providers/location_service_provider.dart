import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/location_service_model.dart';
import 'package:utils/log.dart';
import 'package:get/get.dart';

class LocationServiceProvider extends BaseProvider {
  /// Get location services for a specific profile and location
  ///
  /// [profileId] - The profile ID
  /// [locationId] - The location ID
  ///
  /// Returns a list of [LocationServiceModel]
  ///
  /// Example:
  /// ```dart
  /// final services = await getLocationServices(
  ///   'fcfe87f2-1f07-4e04-b333-ac56d54bd151',
  ///   '093cf315-bac7-4802-abdb-674925f04628',
  /// );
  /// ```
  Future<List<LocationServiceModel>> getLocationServices(
    String profileId,
    String locationId,
  ) async {
    final response = await get(
      '/profiles/$profileId/locations/$locationId/services',
    );

    Log('GET /profiles/$profileId/locations/$locationId/services');
    Log(response.body);

    if ((response.body?["ok"] ?? false) != true) {
      return [];
    }

    return response.body?["data"] != null
        ? LocationServiceModel.listFromJson(response.body?["data"])
        : [];
  }

  /// Upsert (create or update) location services
  ///
  /// [profileId] - The profile ID
  /// [locationId] - The location ID
  /// [services] - List of services to upsert. Each service can have:
  ///   - id (optional): If provided, updates existing service
  ///   - name: Service name
  ///   - duration: Duration in minutes
  ///   - price: Service price
  ///   - category_id: Category/subcategory ID
  ///   - is_active: Whether the service is active
  ///
  /// Returns updated list of [LocationServiceModel] on success, empty list on failure
  ///
  /// Example:
  /// ```dart
  /// final services = await upsertLocationServices(
  ///   'fcfe87f2-1f07-4e04-b333-ac56d54bd151',
  ///   '093cf315-bac7-4802-abdb-674925f04628',
  ///   [
  ///     {
  ///       'name': 'Corte',
  ///       'duration': 30,
  ///       'price': 18000,
  ///       'category_id': '6501154a-b59b-40f1-8ace-eebb4294aa83',
  ///       'is_active': true,
  ///     }
  ///   ],
  /// );
  /// ```
  Future<List<LocationServiceModel>> upsertLocationServices(
    String profileId,
    String locationId,
    List<Map<String, dynamic>> services,
  ) async {
    final response = await put(
      '/profiles/$profileId/locations/$locationId/services',
      {'services': services},
    );

    Log('PUT /profiles/$profileId/locations/$locationId/services');
    Log(response.body);

    if ((response.body?["ok"] ?? false) != true) {
      return [];
    }

    return response.body?["data"] != null
        ? LocationServiceModel.listFromJson(response.body?["data"])
        : [];
  }
}
