import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/artist_location_model.dart';

class ArtistLocationProvider extends BaseProvider {
  createLocation(
    String artistId,
    String name,
    String address,
    Map<String, double>? location, {
    String? address2,
    String? city,
    String? state,
    String? country,
  }) async {
    final response = await post('/artists/$artistId/locations', {
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
                'coordinates': [location['longitude'], location['latitude']],
              }
              : null,
    });

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    return response.body?["data"] != null
        ? ArtistLocationModel.fromJson(response.body?["data"])
        : null;
  }
}
