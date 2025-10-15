import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/location_service_model.dart';
import 'package:core/data/models/shared/abstract/selectable_entity.dart';

class ArtistLocationServiceModel extends SelectableEntity {
  ArtistLocationServiceModel({
    this.id = '',
    required this.name,
    required this.duration,
    required this.price,
    this.categoryId,
    this.artist,
    this.items = const [],
  });

  @override
  String id;
  @override
  String? name;

  String? categoryId;
  int duration;
  double price;

  ProfileModel? artist;
  List<LocationServiceModel> items;

  factory ArtistLocationServiceModel.fromJson(Map<String, dynamic> json) {
    return ArtistLocationServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      duration: json['duration'] as int,
      price: (json['price'] as num).toDouble(),
      items:
          json['items'] != null
              ? LocationServiceModel.listFromJson(json['items'])
              : [],
      artist:
          json['artist'] != null ? ProfileModel.fromJson(json['artist']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'price': price,
      'items': items.map((item) => item.toJson()).toList(),
      'artist': artist?.toJson(),
    };
  }

  static List<ArtistLocationServiceModel> listFromJson(
    List<dynamic>? jsonData,
  ) {
    return jsonData != null
        ? jsonData
            .map((service) => ArtistLocationServiceModel.fromJson(service))
            .toList()
        : [];
  }
}
