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

  updateLocation(
    String profileId,
    String locationId, {
    String? name,
    String? address,
    String? address2,
    String? city,
    String? state,
    String? country,
    LatLng? location,
  }) async {
    final Map<String, dynamic> body = {};

    if (name != null) body['name'] = name;
    if (address != null) body['address'] = address;
    if (address2 != null) body['address2'] = address2;
    if (city != null) body['city'] = city;
    if (state != null) body['state'] = state;
    if (country != null) body['country'] = country;
    if (location != null) {
      body['location'] = {
        'longitude': location.longitude,
        'latitude': location.latitude,
      };
    }

    final response = await put(
      '/profiles/$profileId/locations/$locationId',
      body,
    );

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    return response.body?["data"] != null
        ? LocationModel.fromJson(response.body?["data"])
        : null;
  }

  markSetupStepComplete(
    String profileId,
    String locationId, {
    required LocationSetupStep step,
  }) async {
    final response = await post(
      '/profiles/$profileId/locations/$locationId/setup-step-complete',
      {'step': step.toJson()},
    );

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    return response.body?["data"];
  }
}
