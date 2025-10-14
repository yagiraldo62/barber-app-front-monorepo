import 'package:core/data/models/location_service_model.dart';
import 'package:core/modules/services/providers/location_service_provider.dart';
import 'package:utils/log.dart';
import 'package:utils/snackbars.dart';
import 'package:get/get.dart';

class LocationServiceRepository {
  final LocationServiceProvider locationServiceProvider =
      Get.find<LocationServiceProvider>();

  /// Get location services for a specific profile and location
  ///
  /// [profileId] - The profile ID
  /// [locationId] - The location ID
  ///
  /// Returns a list of [LocationServiceModel] or empty list on error
  Future<List<LocationServiceModel>> getLocationServices(
    String profileId,
    String locationId,
  ) async {
    try {
      Log('getLocationServices: profileId=$profileId, locationId=$locationId');

      final response = await locationServiceProvider.getLocationServices(
        profileId,
        locationId,
      );

      Log('Response: ${response.length} services found');

      return response;
    } catch (e) {
      Log('Error in getLocationServices: $e');

      Snackbars.error(
        title: "Error al cargar servicios",
        message: e.toString(),
      );

      return <LocationServiceModel>[];
    }
  }

  /// Upsert (create or update) location services
  ///
  /// [profileId] - The profile ID
  /// [locationId] - The location ID
  /// [services] - List of services to upsert. Each service should be a Map with:
  ///   - id (optional): If provided, updates existing service
  ///   - name: Service name
  ///   - duration: Duration in minutes
  ///   - price: Service price
  ///   - category_id: Category/subcategory ID
  ///   - is_active: Whether the service is active
  ///   - description (optional): Service description
  ///
  /// Returns updated list of [LocationServiceModel] on success, empty list on failure
  ///
  /// Example:
  /// ```dart
  /// final updatedServices = await upsertLocationServices(
  ///   'fcfe87f2-1f07-4e04-b333-ac56d54bd151',
  ///   '093cf315-bac7-4802-abdb-674925f04628',
  ///   [
  ///     {
  ///       'name': 'Corte',
  ///       'duration': 30,
  ///       'price': 18000,
  ///       'category_id': '6501154a-b59b-40f1-8ace-eebb4294aa83',
  ///       'is_active': true,
  ///     },
  ///     {
  ///       'id': '36bed773-4f66-4224-867d-c3aa4de720ff',
  ///       'name': 'Corte actualizado',
  ///       'duration': 45,
  ///       'price': 20000,
  ///       'category_id': '6501154a-b59b-40f1-8ace-eebb4294aa83',
  ///       'is_active': true,
  ///     },
  ///   ],
  /// );
  /// ```
  Future<List<LocationServiceModel>> upsertLocationServices(
    String profileId,
    String locationId,
    List<Map<String, dynamic>> services,
  ) async {
    try {
      Log(
        'upsertLocationServices: profileId=$profileId, locationId=$locationId',
      );
      Log('Services to upsert: ${services.length}');

      final response = await locationServiceProvider.upsertLocationServices(
        profileId,
        locationId,
        services,
      );

      Log('Response: ${response.length} services returned');

      if (response.isNotEmpty) {
        Snackbars.success(
          title: "Servicios actualizados",
          message: "Los servicios se han actualizado correctamente",
        );
      }

      return response;
    } catch (e) {
      Log('Error in upsertLocationServices: $e');

      Snackbars.error(
        title: "Error al actualizar servicios",
        message: e.toString(),
      );

      return <LocationServiceModel>[];
    }
  }
}
