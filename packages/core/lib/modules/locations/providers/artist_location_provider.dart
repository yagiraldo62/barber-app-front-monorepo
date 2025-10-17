import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/shared/location_model.dart';
import 'package:utils/log.dart';
import 'package:latlong2/latlong.dart';

class ArtistLocationProvider extends BaseProvider {
  createLocation(
    String profileId,
    String name,
    String address,
    LatLng? location, {
    String? address2,
    String? city,
    String? state,
    String? country,
  }) async {
    Log({
      'name': name,
      'address': address,
      'address2': address2,
      'city': city,
      'state': state,
      'country': country,
      'location':
          location != null
              ? {
                'type': 'Point',
                'coordinates': [location.longitude, location.latitude],
              }
              : null,
    });
    final response = await post('/profiles/$profileId/locations', {
      'name': name,
      'address': address,
      'address2': address2,
      'city': city,
      'state': state,
      'country': country,
      'location':
          location != null
              ? {'longitude': location.longitude, 'latitude': location.latitude}
              : null,
    });

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    return response.body?["data"] != null
        ? LocationModel.fromJson(response.body?["data"])
        : null;
  }
}
