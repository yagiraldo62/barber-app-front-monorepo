import 'package:base/providers/base_provider.dart';
import 'package:utils/log.dart';
import 'package:core/modules/services/classes/location_services_item_model.dart';

class ArtistLocationServiceProvider extends BaseProvider {
  Future<List<LocationServicesItemModel>> getLocationServices(
    String artistId,
    String artistLocationId, {
    bool? withNonSelected = false,
  }) async {
    final response = await get(
      '/artists/$artistId/locations/$artistLocationId/services?withNonSelected=$withNonSelected',
    );
    Log(response.request?.url);
    Log(response.headers);
    Log(response.body);

    if ((response.body?["ok"] ?? false) != true) {
      return [];
    }

    return response.body?["data"] != null
        ? LocationServicesItemModel.listFromJson(response.body?["data"])
        : [];
  }

  // upsert
  Future<bool> upsertLocationServices(
    String artistId,
    String artistLocationId,
    List<LocationServicesItemModel> services,
  ) async {
    final response = await put(
      '/artists/$artistId/locations/$artistLocationId/services',
      {'services': services},
    );
    Log(response.request?.url);
    Log(response.headers);
    Log(response.body);

    if ((response.body?["ok"] ?? false) != true) {
      return false;
    }

    return true;
  }
}
