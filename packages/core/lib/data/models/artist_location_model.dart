import 'package:core/data/models/artist_location_service_model.dart';
import 'package:core/data/models/week_day_availability.dart';

class ArtistLocationModel {
  ArtistLocationModel({
    this.id,
    this.name = '',
    this.address,
    this.address2,
    this.city,
    this.state,
    this.country,
    this.location,
    this.isPublished = false,
    this.servicesUp = false,
    this.availabilityUp = false,
    this.services,
    this.availability,
  });

  String? id;
  String name;
  String? address;
  String? address2;
  String? city;
  String? state;
  String? country;
  Map<String, double>? location;
  bool isPublished;
  bool servicesUp;
  bool availabilityUp;
  List<ArtistLocationServiceModel>? services = [];
  List<WeekdayAvailabilityModel>? availability = [];

  factory ArtistLocationModel.fromJson(Map<String, dynamic> jsonData) {
    return ArtistLocationModel()
      ..id = jsonData['id'] as String? ?? ""
      ..name = jsonData['name'] as String? ?? ""
      ..address = jsonData['address'] as String?
      ..address2 = jsonData['address2'] as String?
      ..city = jsonData['city'] as String?
      ..state = jsonData['state'] as String?
      ..country = jsonData['country'] as String?
      ..location =
          jsonData['location'] != null
              ? {
                'latitude': jsonData['location']['coordinates'][1],
                'longitude': jsonData['location']['coordinates'][0],
              }
              : null
      ..isPublished = jsonData['is_published'] as bool? ?? false
      ..servicesUp = jsonData['services_up'] as bool? ?? false
      ..availabilityUp = jsonData['availability_up'] as bool? ?? false
      ..services = ArtistLocationServiceModel.listFromJson(
        jsonData['services'],
      );
    // ..availability = WeekdayAvailabilityModel.listFromJson(
    //   jsonData['availability'],
    // );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'address2': address2,
      'city': city,
      'state': state,
      'country': country,
      'location':
          location != null
              ? {
                'longitude': location!['longitude'],
                'latitude': location!['latitude'],
              }
              : null,
      'is_published': isPublished,
      'services_up': servicesUp,
      'availability_up': availabilityUp,
      'services': services?.map((service) => service.toJson()).toList(),
      'availability':
          availability?.map((available) => available.toJson()).toList(),
    };
  }

  static List<ArtistLocationModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData
              .map((location) => ArtistLocationModel.fromJson(location))
              .toList()
          : [];
}
