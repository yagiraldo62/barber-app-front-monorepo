class LocationServiceModel {
  late String id;
  late String locationId;
  late String name;
  String? description;
  late int duration;
  late num price;
  late bool isActive;
  late String subcategoryId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  LocationServiceModel({
    this.id = "",
    this.locationId = "",
    this.name = "",
    this.description,
    this.duration = 0,
    this.price = 0,
    this.isActive = true,
    this.subcategoryId = "",
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory LocationServiceModel.fromJson(Map<String, dynamic> json) =>
      LocationServiceModel(
        id: json['id'] as String? ?? "",
        locationId: json['location_id'] as String? ?? "",
        name: json['name'] as String? ?? "",
        description: json['description'] as String?,
        duration: json['duration'] as int? ?? 0,
        price: json['price'] as num? ?? 0,
        isActive: json['is_active'] as bool? ?? true,
        subcategoryId: json['subcategory_id'] as String? ?? "",
        createdAt:
            json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : null,
        updatedAt:
            json['updated_at'] != null
                ? DateTime.parse(json['updated_at'] as String)
                : null,
        deletedAt:
            json['deleted_at'] != null
                ? DateTime.parse(json['deleted_at'] as String)
                : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'location_id': locationId,
    'name': name,
    'description': description,
    'duration': duration,
    'price': price,
    'is_active': isActive,
    'subcategory_id': subcategoryId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };

  static List<LocationServiceModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData.map((item) => LocationServiceModel.fromJson(item)).toList()
          : [];
}
