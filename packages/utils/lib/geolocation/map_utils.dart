import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Model to hold address components
class AddressComponents {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? fullAddress;

  AddressComponents({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.fullAddress,
  });

  @override
  String toString() {
    return 'AddressComponents(street: $street, city: $city, state: $state, country: $country, postalCode: $postalCode)';
  }
}

Future<Position?> getUserCurrentLocation() async {
  await Geolocator.requestPermission().then((value) {}).onError((
    error,
    stackTrace,
  ) async {
    await Geolocator.requestPermission();
    print("ERROR$error");
  });
  Position pos = await Geolocator.getCurrentPosition();
  return pos;
}

/// Get address information from latitude and longitude
/// Returns an AddressComponents object with city, state, and country information
Future<AddressComponents?> getAddressFromCoordinates({
  required double latitude,
  required double longitude,
}) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    if (placemarks.isEmpty) {
      return null;
    }

    // Get the first placemark (most accurate result)
    Placemark place = placemarks.first;

    // Build full address
    List<String> addressParts = [];
    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressParts.add(place.country!);
    }

    return AddressComponents(
      street: place.street,
      city: place.locality ?? place.subAdministrativeArea,
      state: place.administrativeArea,
      country: place.country,
      postalCode: place.postalCode,
      fullAddress: addressParts.join(', '),
    );
  } catch (e) {
    print("Error getting address from coordinates: $e");
    return null;
  }
}

/// Get address information from a Position object
Future<AddressComponents?> getAddressFromPosition(Position position) async {
  return getAddressFromCoordinates(
    latitude: position.latitude,
    longitude: position.longitude,
  );
}

/// Get current location and its address information
Future<Map<String, dynamic>?> getCurrentLocationWithAddress() async {
  try {
    Position? position = await getUserCurrentLocation();
    if (position == null) {
      return null;
    }

    AddressComponents? address = await getAddressFromPosition(position);

    return {
      'position': position,
      'address': address,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'city': address?.city,
      'state': address?.state,
      'country': address?.country,
    };
  } catch (e) {
    print("Error getting current location with address: $e");
    return null;
  }
}
