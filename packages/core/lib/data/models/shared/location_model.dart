import 'package:latlong2/latlong.dart';
import 'package:utils/log.dart';

/// Represents physical locations where profiles provide services.
/// Maps to the `locations` table in the database.
class LocationModel {
  LocationModel({
    this.id,
    this.name = '',
    this.country = 'Colombia',
    this.state = 'Antioquia',
    this.city = 'Medellin',
    this.isPublished = false,
    this.rate = 5.0,
    this.locationUp = false,
    this.servicesUp = false,
    this.availabilityUp = false,
  });

  // Primary fields
  String? id;
  String name;
  String? address;
  String? address2;
  String country; // Default 'Colombia'
  String state; // Default 'Antioquia'
  String city; // Default 'Medellin'
  LatLng? location; // Geographic point
  bool isPublished; // Default false
  bool servicesUp; // Services configuration status (also in settings)
  bool availabilityUp; // Availability configuration status (also in settings)

  // Location settings (JSONB field)
  double rate; // Location rating (default: 5)
  bool locationUp; // Location setup completion

  // Timestamps
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Relations
  // ProfileModel? profile; // Many-to-one with Profile
  // List<LocationMemberModel>? members;
  // List<LocationAvailabilityModel>? availability;
  // List<AppointmentModel>? appointments;
  // List<LocationServiceModel>? services;

  /// Factory constructor from JSON
  factory LocationModel.fromJson(Map<String, dynamic> jsonData) {
    final locationSettings =
        jsonData['location_settings'] as Map<String, dynamic>? ?? {};
    return LocationModel(
        id: jsonData['id'] as String? ?? '',
        name: jsonData['name'] as String? ?? '',
      )
      ..address = jsonData['address'] as String?
      ..address2 = jsonData['address2'] as String?
      ..country = jsonData['country'] as String? ?? 'Colombia'
      ..state = jsonData['state'] as String? ?? 'Antioquia'
      ..city = jsonData['city'] as String? ?? 'Medellin'
      ..location =
          jsonData['location'] != null
              ? jsonData['location']['coordinates'] != null
                  ? LatLng(
                    (jsonData['location']['coordinates'][0] as num).toDouble(),
                    (jsonData['location']['coordinates'][1] as num).toDouble(),
                  )
                  : LatLng(
                    (jsonData['location']['latitude'] as num).toDouble(),
                    (jsonData['location']['longitude'] as num).toDouble(),
                  )
              : null
      ..isPublished = jsonData['is_published'] as bool? ?? false
      ..servicesUp = jsonData['services_up'] as bool? ?? false
      ..availabilityUp = jsonData['availability_up'] as bool? ?? false
      // Location settings (from JSONB field)
      ..rate = (locationSettings['rate'] as num?)?.toDouble() ?? 5.0
      ..locationUp = locationSettings['location_up'] as bool? ?? false
      ..servicesUp = locationSettings['services_up'] as bool? ?? false
      ..availabilityUp = locationSettings['availability_up'] as bool? ?? false
      // Timestamps
      ..createdAt =
          jsonData['created_at'] != null
              ? DateTime.parse(jsonData['created_at'])
              : null
      ..updatedAt =
          jsonData['updated_at'] != null
              ? DateTime.parse(jsonData['updated_at'])
              : null
      ..deletedAt =
          jsonData['deleted_at'] != null
              ? DateTime.parse(jsonData['deleted_at'])
              : null;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'address2': address2,
      'country': country,
      'state': state,
      'city': city,
      'location':
          location != null
              ? {
                'longitude': location!.longitude,
                'latitude': location!.latitude,
              }
              : null,
      'is_published': isPublished,
      'services_up': servicesUp,
      'availability_up': availabilityUp,
      'location_settings': {
        'rate': rate,
        'location_up': locationUp,
        'services_up': servicesUp,
        'availability_up': availabilityUp,
      },
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Convert to simplified JSON
  Map<String, dynamic> toSimplifiedJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'is_published': isPublished,
    };
  }

  /// Convert list from JSON
  static List<LocationModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData
              .map((location) => LocationModel.fromJson(location))
              .toList()
          : [];
}
